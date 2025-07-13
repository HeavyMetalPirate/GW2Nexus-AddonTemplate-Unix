FROM fedora:42 AS builder
RUN dnf install -y \
    git \
    which \
    clang \
    clang-tools-extra \
    lld \
    llvm \
    make \
    cmake \
    pipx \
    wget \
    && dnf clean all && rm -rf /var/cache/dnf

# Install conan
RUN pipx install conan && pipx ensurepath
ENV PATH="/root/.local/bin:${PATH}"

# Verify installation of tools
RUN which clang-cl; \
    which lld-link; \
    which llvm-lib; \
    which llvm-rc; \
    conan --version;

# xwin setup
ENV XWIN_VERSION=0.6.6
# environment variables for SDK/CRT
ENV XWIN_DIR=/opt/xwin
ENV XWIN_CACHE_DIR=${XWIN_DIR}/.xwin-cache
ENV XWIN_REDIST_DIR=/xwin
ENV WINSDK_DIR=${XWIN_REDIST_DIR}/sdk
ENV VCTOOLS_DIR=${XWIN_REDIST_DIR}/crt

RUN wget https://github.com/Jake-Shadle/xwin/releases/download/${XWIN_VERSION}/xwin-${XWIN_VERSION}-x86_64-unknown-linux-musl.tar.gz -O /tmp/xwin.tar.gz \
    && mkdir -p ${XWIN_DIR} \
    && tar --no-same-owner -xf /tmp/xwin.tar.gz -C ${XWIN_DIR}
# extract SDK/CRT
RUN ${XWIN_DIR}/xwin-${XWIN_VERSION}-x86_64-unknown-linux-musl/xwin --accept-license --cache-dir ${XWIN_CACHE_DIR} splat --output ${XWIN_REDIST_DIR} --include-debug-libs

# Conan Recipes stuff
COPY modules/builder/conan /conan
RUN conan profile detect --force; \
    conan export /conan/recipes/imgui --version=1.80; \
    conan export /conan/recipes/generic --version=v1.2 --name=rcgg-arcdps-api; \
    conan export /conan/recipes/generic --version=latest --name=rcgg-mumble-api; \
    conan export /conan/recipes/generic --version=v6.1 --name=rcgg-nexus-api;

# Debug Build
FROM builder as build-debug
ARG ADDON_OUTPUT_NAME=clion_demo
WORKDIR /addon/build-debug
COPY . .
RUN rm -f ../CMakeCache.txt && rm -rf build/ # Clean previous build artifacts
RUN conan install . --build=missing --profile /conan/profiles/windows  -s build_type=Debug -s compiler.runtime_type=Debug
RUN cmake --preset conan-debug; \
    cmake --build --preset conan-debug;

# Release Build
FROM builder as build-release
ARG ADDON_OUTPUT_NAME=clion_demo
WORKDIR /addon/build-release
COPY . .
RUN rm -f ../CMakeCache.txt && rm -rf build/ # Clean previous build artifacts
RUN conan install . --build=missing --profile /conan/profiles/windows
RUN cmake --preset conan-release; \
    cmake --build --preset conan-release;

FROM scratch AS export-stage
ARG ADDON_OUTPUT_NAME=clion_demo
COPY --from=build-debug /addon/build-debug/build/Debug/${ADDON_OUTPUT_NAME}.dll ./${ADDON_OUTPUT_NAME}-Debug.dll
COPY --from=build-release /addon/build-release/build/Release/${ADDON_OUTPUT_NAME}.dll ./${ADDON_OUTPUT_NAME}.dll
