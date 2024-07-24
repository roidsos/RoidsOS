setup: 
	mkdir -p iso
	mkdir -p iso/boot
	mkdir -p iso/EFI/BOOT
	mkdir -p initramfs/bin
depends:
	$(MAKE) -C Hornet 
	$(MAKE) -C limine

iso: setup depends
	cp cfg/limine.cfg limine/limine.sys limine/limine-cd.bin limine/limine-cd-efi.bin iso/
	cp Hornet/kernel.elf iso/boot/hornet.elf
	cp limine/BOOT*.EFI iso/EFI/BOOT/

	xorriso -as mkisofs -b limine-cd.bin \
		-no-emul-boot -boot-load-size 4 -boot-info-table \
		--efi-boot limine-cd-efi.bin \
		-efi-boot-part --efi-boot-image --protective-msdos-label \
		iso -o os.iso
	limine/limine-deploy os.iso

	rm -rf iso


run: iso
	qemu-system-x86_64 -cdrom os.iso -hda hdd.img -m 256M -serial file:hornet.log -machine q35 --boot order=d
debug: iso
	qemu-system-x86_64 -no-reboot -serial stdio -d int -no-shutdown -cdrom os.iso -hda hdd.img -m 256M -machine q35 --boot order=d
debug-gdb: iso
	qemu-system-x86_64 -s -S -no-reboot -serial stdio -d int -no-shutdown -cdrom os.iso -hda hdd.img -m 256M -machine q35 --boot order=d
clean:
	$(MAKE) -C h0r.net clean
