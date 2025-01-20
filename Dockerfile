FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y \
        vim wget unzip u-boot-qemu \
        autoconf automake autotools-dev curl python3 python3-pip python3-tomli libmpc-dev libmpfr-dev libgmp-dev gawk build-essential bison flex texinfo gperf libtool patchutils bc zlib1g-dev libexpat-dev ninja-build git cmake libglib2.0-dev libslirp-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN cd /tmp \
    && git clone https://github.com/riscv-collab/riscv-gnu-toolchain.git \
    && cd riscv-gnu-toolchain \
    && git checkout 2024.12.16 \
    && ./configure --enable-qemu-system --prefix=/opt/riscv-qemu --with-arch=rv64gcv_zbi --with-abi=lp64d \
    && make -j$(nproc) build-sim SIM=qemu \
    && cd build-qemu \
    && make install \
    && rm -rf /tmp/riscv-gnu-toolchain

ENV PATH="/opt/riscv-qemu/bin:$PATH"

RUN wget https://github.com/riscv-collab/riscv-gnu-toolchain/releases/download/2024.12.16/riscv64-glibc-ubuntu-22.04-gcc-nightly-2024.12.16-nightly.tar.xz -O /tmp/riscv-toolchain.tar.xz \
    && mkdir -p /opt/riscv-toolchain \
    && tar -xf /tmp/riscv-toolchain.tar.xz -C /opt/riscv-toolchain --strip-components=1 \
    && rm /tmp/riscv-toolchain.tar.xz

ENV PATH="/opt/riscv-toolchain/bin:$PATH"

COPY dqib_riscv64-virt.zip /tmp/dqib_riscv64-virt.zip
RUN unzip /tmp/dqib_riscv64-virt.zip -d /opt \
    && rm /tmp/dqib_riscv64-virt.zip

COPY riscv_qemu.sh /usr/local/bin/riscv_qemu.sh
RUN chmod +x /usr/local/bin/riscv_qemu.sh
