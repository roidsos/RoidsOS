TARGET ?= x86_64-no_bl

deps:
	@if [ ! -d "Hornet/bin" ]; then \
		git submodule update --init Hornet; \
	fi
	@if [ ! -d "hboot/bin" ]; then \
		git submodule update --init hboot; \
	fi
	TARGET=$(TARGET) $(MAKE) -C Hornet all
ifneq ($(TARGET), x86_64-no_bl)
	TARGET=$(TARGET) $(MAKE) -C hboot all
endif

hdd: deps
	dd if=/dev/zero of=os.img bs=512 count=93750
	mkfs -t vfat os.img
	mmd -i os.img ::/EFI
	mmd -i os.img ::/EFI/BOOT
ifeq ($(TARGET), x86_64-no_bl) #TODO: check for just the end not the whole string
	mcopy -i os.img Hornet/bin/hornet.efi ::/EFI/BOOT/BOOTX64.efi
else
	mcopy -i os.img hboot/bin/hboot.efi ::/EFI/BOOT/BOOTX64.efi
endif

run: hdd
	qemu-system-x86_64 -hda os.img -m 256M -serial file:hornet.log -machine q35 --boot order=d
run-uefi: hdd
	qemu-system-x86_64 -hda os.img -m 256M -serial file:hornet.log -machine q35 --boot order=d -drive if=pflash,format=raw,readonly=on,file=/usr/share/ovmf/x64/OVMF.fd
debug: hdd
	qemu-system-x86_64 -no-reboot -serial stdio -d int -no-shutdown -hda os.img -m 256M -machine q35 --boot order=d
debug-uefi: hdd
	qemu-system-x86_64 -no-reboot -serial stdio -d int -no-shutdown -hda os.img -m 256M -machine q35 --boot order=d -drive if=pflash,format=raw,readonly=on,file=/usr/share/ovmf/x64/OVMF.fd
debug-gdb: hdd
	qemu-system-x86_64 -s -S -no-reboot -serial stdio -d int -no-shutdown -hda os.img -m 256M -machine q35 --boot order=d
debug-gdb-uefi: hdd
	qemu-system-x86_64 -s -S -no-reboot -serial stdio -d int -no-shutdown -hda os.img -m 256M -machine q35 --boot order=d -drive if=pflash,format=raw,readonly=on,file=/usr/share/ovmf/x64/OVMF.fd
clean:
	$(MAKE) -C h0r.net clean
