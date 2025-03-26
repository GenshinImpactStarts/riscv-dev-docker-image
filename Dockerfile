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
    && ./configure --enable-linux --enable-qemu-system --prefix=/opt/riscv-toolchain --with-arch=rv64gcv --with-abi=lp64d \
    && make -j$(nproc) linux build-sim SIM=qemu \
    && rm -rf /tmp/riscv-gnu-toolchain

ENV PATH="/opt/riscv-toolchain/bin:$PATH"

RUN wget https://media.githubusercontent.com/media/GenshinImpactStarts/riscv-dev-docker-image/refs/heads/main/dqib_riscv64-virt.zip -O /tmp/dqib_riscv64-virt.zip \
    && unzip /tmp/dqib_riscv64-virt.zip -d /opt \
    && rm /tmp/dqib_riscv64-virt.zip

RUN wget https://raw.githubusercontent.com/GenshinImpactStarts/riscv-dev-docker-image/refs/heads/main/riscv_qemu.sh -O /usr/local/bin/riscv_qemu.sh \
    && chmod +x /usr/local/bin/riscv_qemu.sh
