# Docker Image for RISC-V Development

This repository contains a Dockerfile for building a Docker image for Linux-based RISC-V development. The image is based on Ubuntu 22.04 and contains the following tools:
- RISC-V GNU Toolchain
- QEMU
- Debian Image for RISC-V in QEMU with gdbserver and auto-mounted shared folder

The docker image is available on Docker Hub: [genshinimpactstarts/riscv-dev](https://hub.docker.com/r/genshinimpactstarts/riscv-dev).

### Debian Image

The Debian image in QEMU is in `dqib_riscv64-virt.zip` file, which is based on [https://people.debian.org/~gio/dqib/](https://people.debian.org/~gio/dqib/). The modified image is installed with gdb, gdbserver, vim. And a shared folder is mounted defaultly on /mnt by editing the /etc/fstab file.

### Usage

Enter the docker container.

Modify the `riscv_qemu.sh` script to your needs.

```bash
vim $(which riscv_qemu.sh)
```

**Especially the path to the shared folder in your docker container.**

Run the script to start QEMU.

```bash
riscv_qemu.sh
```

You can login with root:root or debian:debian.

Port 22222 is forwarded for SSH access. Port 1234 is forwarded for any other use like gdbserver. You can change the port forwarding in the script `riscv_qemu.sh`.

### Cross Compile and Debug

You should compile your RISC-V program with the RISC-V GNU Toolchain in your docker container. **Not in the QEMU.**

```bash
riscv64-unknown-linux-gnu-g++ foo.cpp -o foo
```

Assume you have a RISC-V program `foo` under the shared folder. You can debug it with gdb or gdbserver in the QEMU.

```bash
gdbserver :1234 /mnt/foo
```

Outside the QEMU, you can connect to the gdbserver with the RISC-V GNU Toolchain.

```bash
riscv64-unknown-linux-gnu-gdb foo
(gdb) target remote localhost:1234
```
