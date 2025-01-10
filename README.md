# Docker Image for RISC-V Development

This repository contains a Dockerfile for building a Docker image for Linux-based RISC-V development. The image is based on Ubuntu 22.04 and contains the following tools:
- RISC-V GNU Toolchain (glibc)
- QEMU
- Debian Image for RISC-V in QEMU with gdbserver and auto-mounted shared folder

The docker image is available on Docker Hub: [genshinimpactstarts/riscv-dev](https://hub.docker.com/r/genshinimpactstarts/riscv-dev).

Some vscode configurations are also included in this repository for RISC-V development.

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

### VSCode Configuration

The purpose of my giving the vscode configurations is to give a reference for you to configure your own. So the configurations only implement some basic functions like compile a single file and debug it. If you want to use it in a more complex project, you need to modify it by yourself.

These configurations are under `vscode_config` folder and not included in the docker image. You can use `qemu` task to start qemu, use `g++` task to compile the file being currently edited, and launch debug directly which runs gdbserver and attach to it automatically.

**NOTE:** The command is sent to QEMU using `sshpass`, so you need to install it first. Since not everyone needs it, it is not included in the Dockerfile.

**NOTE:** Since only port 1234 is forwarded for gdbserver, I use `pkill` every time before starting gdbserver to avoid the port being occupied. So only one debug session can be run at the same time. If you want to run multiple debug sessions, you need to achieve it by yourself.

`settings.json` and `.clangd` are only used for the clangd extension in VSCode to make it search the RISC-V GNU Toolchain headers. If you don't use the clangd extension or you have your own configurations, you can ignore them.

### About the Huge Size of the Docker Image (~5GB)

Size of tools:
- RISC-V GNU Toolchain: ~2.5GB
- apt packages: ~1GB
- Debian Image: ~1GB

What can I say.

An ~500MB layer copying the zip file of the Debian image can be avoided. But I'm too lazy to optimize it.
