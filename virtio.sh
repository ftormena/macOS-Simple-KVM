#!/bin/bash

OSK="ourhardworkbythesewordsguardedpleasedontsteal(c)AppleComputerInc"
VMDIR=$PWD
OVMF=$VMDIR/firmware
#export QEMU_AUDIO_DRV=pa
#QEMU_AUDIO_DRV=pa
#    -device ich9-intel-hda -device hda-output \

qemu-system-x86_64 \
    -nodefaults \
    -enable-kvm \
    -m 4G \
    -machine q35,accel=kvm \
    -smp 8,cores=4 \
    -cpu Penryn,vendor=GenuineIntel,kvm=on,+sse3,+sse4.2,+aes,+xsave,+avx,+xsaveopt,+xsavec,+xgetbv1,+avx2,+bmi2,+smep,+bmi1,+fma,+movbe,+invtsc \
    -device isa-applesmc,osk="$OSK" \
    -smbios type=2 \
    -drive if=pflash,format=raw,readonly=on,file="$OVMF/OVMF_CODE.fd" \
    -drive if=pflash,format=raw,file="$OVMF/OVMF_VARS-1024x768.fd" \
    -vga qxl \
    -audio driver=pa,model=virtio \
    -usb -device usb-kbd -device usb-mouse \
    -netdev user,id=net0 \
    -device vmxnet3,netdev=net0,id=net0,mac=9c:8b:a0:67:61:7a \
    -drive id=ESP,if=none,format=qcow2,file=ESP.qcow2     -device virtio-blk,drive=ESP \
    -drive id=OS,if=none,format=qcow2,file=macOS.qcow2     -device virtio-blk,drive=OS \
    -drive id=InstallMedia,format=raw,if=none,file=BaseSystem.img  -device virtio-blk,drive=InstallMedia \
