#!/bin/sh
# Boot RISC-V 64-bit Debian with QEMU

CPU_NUM=4
MEM_SIZE=4G
IMAGE_PATH=/opt/dqib_riscv64-virt/image.qcow2
SHARED_DIR=/path/to/your/shared  # Change this to your shared directory
# Default shared directory in guest is /mnt. You can change it in /etc/fstab
# hostshare /path/to/mount/point 9p trans=virtio 0 0

qemu-system-riscv64 -nographic -machine virt -m $MEM_SIZE -smp $CPU_NUM -cpu rv64,v=true,zba=true,vlen=256 \
    -bios /usr/lib/riscv64-linux-gnu/opensbi/generic/fw_jump.elf \
    -kernel /usr/lib/u-boot/qemu-riscv64_smode/uboot.elf \
    -object rng-random,filename=/dev/urandom,id=rng0 -device virtio-rng-device,rng=rng0 \
    -append "console=ttyS0 root=LABEL=rootfs" \
    -device virtio-blk-device,drive=hd -drive file=$IMAGE_PATH,if=none,id=hd \
    -device virtio-net-device,netdev=usernet -netdev user,id=usernet,hostfwd=tcp::22222-:22,hostfwd=tcp::1234-:1234 \
    -virtfs local,path=$SHARED_DIR,mount_tag=hostshare,security_model=passthrough,id=hostshare
# port 22222 is for ssh, port 1234 is for gdbserver
# gdbserver :1234 /path/to/your/program