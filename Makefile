all:
	cd h0r.net && $(MAKE) && cd .. 

	$(MAKE) -C limine

	mkdir -p iso
	mkdir -p iso/boot
	mkdir -p iso/EFI/BOOT
	mkdir -p initramfs/bin

	nasm -f elf64 -o testexec/test.o testexec/test.asm
	ld -o initramfs/bin/test testexec/test.o

	cp cfg/limine.cfg limine/limine.sys limine/limine-cd.bin limine/limine-cd-efi.bin iso/
	cp h0r.net/kernel.elf iso/boot/h0rnet.elf
	cp assets/kfont.psf iso/boot/
	cp limine/BOOT*.EFI iso/EFI/BOOT/
	cp cfg/startup.nsh iso/startup.nsh
	
	cd initramfs && tar -c -f ../iso/boot/initramfs.tar --format v7 *

	xorriso -as mkisofs -b limine-cd.bin \
		-no-emul-boot -boot-load-size 4 -boot-info-table \
		--efi-boot limine-cd-efi.bin \
		-efi-boot-part --efi-boot-image --protective-msdos-label \
		iso -o os.iso
	limine/limine-deploy os.iso
override CFILES := $(shell find -L h0r.net/src -type f -name '*.c')
format:
	clang-format -i ${CFILES}

run: all
	qemu-system-x86_64 -cdrom os.iso -hda hdd.img -m 256M -serial file:hornet.log -machine q35 --boot order=d
runuefi: all
	qemu-system-x86_64 -cdrom os.iso -hda hdd.img -m 256M -serial file:hornet.log -machine q35 --boot order=d -drive if=pflash,format=raw,unit=0,file="OVMFbin/OVMF_CODE-pure-efi.fd",readonly=on -drive if=pflash,format=raw,unit=1,file="OVMFbin/OVMF_VARS-pure-efi.fd"
debug: all
	qemu-system-x86_64 -no-reboot -serial stdio -d int -no-shutdown -cdrom os.iso -hda hdd.img -m 256M -machine q35 --boot order=d
debuguefi: all
	qemu-system-x86_64 -no-reboot -serial stdio -d int -no-shutdown -cdrom os.iso -hda hdd.img -m 256M -machine q35 --boot order=d -drive if=pflash,format=raw,unit=0,file="OVMFbin/OVMF_CODE-pure-efi.fd",readonly=on -drive if=pflash,format=raw,unit=1,file="OVMFbin/OVMF_VARS-pure-efi.fd"
debugr: all
	qemu-system-x86_64 -s -S -no-reboot -serial stdio -d int -no-shutdown -cdrom os.iso -hda hdd.img -m 256M -machine q35 --boot order=d
debugruefi: all
	qemu-system-x86_64 -s -S -no-reboot -serial stdio -d int -no-shutdown -cdrom os.iso -hda hdd.img -m 256M -machine q35 --boot order=d -drive if=pflash,format=raw,unit=0,file="OVMFbin/OVMF_CODE-pure-efi.fd",readonly=on -drive if=pflash,format=raw,unit=1,file="OVMFbin/OVMF_VARS-pure-efi.fd"
clean:
# JUST DELETES JUNK LIKE OBJECT FILES - fuck capslock
	make -C h0r.net clean
	rm -rf h0r.net/kernel.bin iso
