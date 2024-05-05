all:
# builds the kernel
	cp limine/limine.h h0r.net/src/limine.h
	cd h0r.net && $(MAKE) && cd .. 
# build limine
	$(MAKE) -C limine
#make an ISO
	mkdir -p iso
	mkdir -p iso/boot
	cp cfg/limine.cfg limine/limine.sys limine/limine-cd.bin limine/limine-cd-efi.bin iso/
	cp h0r.net/kernel.elf iso/boot/h0rnet.elf
	cp assets/kfont.psf iso/boot/
	mkdir -p iso/EFI/BOOT
	cp limine/BOOT*.EFI iso/EFI/BOOT/
	cp cfg/startup.nsh iso/startup.nsh
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
# runs using qemu
	qemu-system-x86_64 -cdrom os.iso -m 256M -serial file:hornet.log -machine q35 -audiodev sdl,id=snd0 -machine pcspk-audiodev=snd0

runuefi: all
# runs using qemu
	qemu-system-x86_64 -cdrom os.iso -m 256M -serial file:hornet.log -machine q35 -drive if=pflash,format=raw,unit=0,file="OVMFbin/OVMF_CODE-pure-efi.fd",readonly=on -drive if=pflash,format=raw,unit=1,file="OVMFbin/OVMF_VARS-pure-efi.fd"
debug: all
# standard qemu debug
	qemu-system-x86_64 -no-reboot -serial stdio -d int -no-shutdown -cdrom os.iso -m 256M -machine q35
debuguefi: all
#remote debug using GDB
	qemu-system-x86_64 -no-reboot -serial stdio -d int -no-shutdown -cdrom os.iso -m 256M -machine q35 -drive if=pflash,format=raw,unit=0,file="OVMFbin/OVMF_CODE-pure-efi.fd",readonly=on -drive if=pflash,format=raw,unit=1,file="OVMFbin/OVMF_VARS-pure-efi.fd"
debugr: all
#remote debug using GDB
	qemu-system-x86_64 -s -S -no-reboot -serial stdio -d int -no-shutdown -cdrom os.iso -m 256M  -machine q35

debugruefi: all
#remote debug using GDB
	qemu-system-x86_64 -s -S -no-reboot -serial stdio -d int -no-shutdown -cdrom os.iso -m 256M -machine q35 -drive if=pflash,format=raw,unit=0,file="OVMFbin/OVMF_CODE-pure-efi.fd",readonly=on -drive if=pflash,format=raw,unit=1,file="OVMFbin/OVMF_VARS-pure-efi.fd"
clean:
# JUST DELETES JUNK LIKE OBJECT FILES - fuck capslock
	make -C h0r.net/src clean
	rm -rf h0r.net/src/kernel.bin iso
