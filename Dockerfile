FROM fedora:43 AS builder
RUN dnf install -y \
    clang \
    clang-tools-extra \
    lld \
    llvm \
    cmake \
    ninja-build \
    wget \
    && dnf clean all

RUN command -v lld-link
RUN command -v llvm-rc
RUN command -v clang-cl

# xwin
ENV XWIN_VERSION=0.6.6
# environment variables for SDK/CRT
ENV XWIN_DIR=/opt/xwin/xwin-${XWIN_VERSION}-x86_64-unknown-linux-musl
ENV XWIN_CACHE_DIR=/opt/xwin/.xwin-cache
ENV XWIN_REDIST_DIR=${XWIN_DIR}/redist
ENV WINSDK_DIR=${XWIN_REDIST_DIR}/sdk
ENV VCTOOLS_DIR=${XWIN_REDIST_DIR}/crt

RUN wget https://github.com/Jake-Shadle/xwin/releases/download/${XWIN_VERSION}/xwin-${XWIN_VERSION}-x86_64-unknown-linux-musl.tar.gz -O /tmp/xwin.tar.gz \
    && mkdir -p /opt/xwin \
    && tar --no-same-owner -xf /tmp/xwin.tar.gz -C /opt/xwin
# extract SDK/CRT
RUN ${XWIN_DIR}/xwin --accept-license --cache-dir ${XWIN_CACHE_DIR} splat --output ${XWIN_REDIST_DIR} --include-debug-libs

# Copy cmake toolchain file
COPY docker/clang-cl-win64.cmake /opt/toolchain/clang-cl-win64.cmake
RUN ls -l /opt/toolchain/ && cat /opt/toolchain/clang-cl-win64.cmake

# Debug Build
FROM builder as build-debug
ARG ADDON_OUTPUT_NAME=clion_demo
WORKDIR /addon
COPY . .
RUN mkdir build-debug
WORKDIR /addon/build-debug
RUN rm -f ../CMakeCache.txt
RUN cmake -G Ninja -DCMAKE_BUILD_TYPE=Debug -DCMAKE_TOOLCHAIN_FILE=/opt/toolchain/clang-cl-win64.cmake -DADDON_OUTPUT_NAME=${ADDON_OUTPUT_NAME} ..
RUN cmake --build . --config Debug --target all -- -j$(nproc)

# Release Build
FROM builder as build-release
ARG ADDON_OUTPUT_NAME=clion_demo
WORKDIR /addon
COPY . .
RUN mkdir build-release
WORKDIR /addon/build-release
RUN rm -f ../CMakeCache.txt
RUN cmake -G Ninja -DCMAKE_BUILD_TYPE:STRING=MinSizeRel -DCMAKE_TOOLCHAIN_FILE=/opt/toolchain/clang-cl-win64.cmake -DADDON_OUTPUT_NAME=${ADDON_OUTPUT_NAME} ..
RUN cmake --build . --config MinSizeRel --target all -- -j$(nproc)

FROM scratch AS export-stage
ARG ADDON_OUTPUT_NAME=clion_demo
COPY --from=build-debug /addon/build-debug/lib${ADDON_OUTPUT_NAME}.dll ./${ADDON_OUTPUT_NAME}-Debug.dll
COPY --from=build-release /addon/build-release/lib${ADDON_OUTPUT_NAME}.dll ./${ADDON_OUTPUT_NAME}.dll
