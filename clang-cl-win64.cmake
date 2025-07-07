set(CMAKE_SYSTEM_NAME Windows)
set(CMAKE_C_COMPILER clang-cl)
set(CMAKE_CXX_COMPILER clang-cl)
set(CMAKE_RC_COMPILER llvm-rc)
set(CMAKE_AR llvm-lib)
set(CMAKE_LINKER lld-link)

set(XWIN_SYSROOT
        /opt/xwin/xwin-0.6.6-x86_64-unknown-linux-musl/redist
)
set(CMAKE_SYSROOT
    ${XWIN_SYSROOT}
)
set(CMAKE_FIND_ROOT_PATH
        ${XWIN_SYSROOT}
)

file(GLOB_RECURSE ALL_INCLUDES
    ${XWIN_SYSROOT}/sdk/include/*
    ${XWIN_SYSROOT}/crt/include/*
)
include_directories(
        ${XWIN_SYSROOT}/crt/include
        ${XWIN_SYSROOT}/crt/include/cliext
        ${XWIN_SYSROOT}/crt/include/CodeAnalysis
        ${XWIN_SYSROOT}/crt/include/CodeAnalysis/ConcurrencyCheck
        ${XWIN_SYSROOT}/crt/include/CodeAnalysis/CppCoreCheck
        ${XWIN_SYSROOT}/crt/include/CodeAnalysis/VariantClear
        ${XWIN_SYSROOT}/crt/include/CodeAnalysis/EnumIndex
        ${XWIN_SYSROOT}/crt/include/CodeAnalysis/HResultCheck
        ${XWIN_SYSROOT}/crt/include/experimental
        ${XWIN_SYSROOT}/crt/include/msclr
        ${XWIN_SYSROOT}/crt/include/msclr/com
        ${XWIN_SYSROOT}/crt/include/Manifest

        ${XWIN_SYSROOT}/sdk/include
        ${XWIN_SYSROOT}/sdk/include/um
        ${XWIN_SYSROOT}/sdk/include/um/winsqlite
        ${XWIN_SYSROOT}/sdk/include/um/gl
        ${XWIN_SYSROOT}/sdk/include/shared
        ${XWIN_SYSROOT}/sdk/include/shared/netcx
        ${XWIN_SYSROOT}/sdk/include/shared/netcx/shared
        ${XWIN_SYSROOT}/sdk/include/shared/netcx/shared/net
        ${XWIN_SYSROOT}/sdk/include/shared/netcx/shared/net/wifi
        ${XWIN_SYSROOT}/sdk/include/shared/ndis
        ${XWIN_SYSROOT}/sdk/include/cppwinrt
        ${XWIN_SYSROOT}/sdk/include/cppwinrt/winrt
        ${XWIN_SYSROOT}/sdk/include/cppwinrt/winrt/impl
        ${XWIN_SYSROOT}/sdk/include/winrt
        ${XWIN_SYSROOT}/sdk/include/winrt/wrl
        ${XWIN_SYSROOT}/sdk/include/winrt/wrl/wrappers
        ${XWIN_SYSROOT}/sdk/include/ucrt
        ${XWIN_SYSROOT}/sdk/include/ucrt/sys
)

set(CMAKE_INCLUDE_PATH
        ${XWIN_SYSROOT}/sdk/include
        ${XWIN_SYSROOT}/crt/include
)
set(CMAKE_LIBRARY_PATH
        ${XWIN_SYSROOT}/sdk/lib/um/x86_64
        ${XWIN_SYSROOT}/sdk/lib/ucrt/x86_64
        ${XWIN_SYSROOT}/crt/lib/x86_64
)

set(CMAKE_C_COMPILER_TARGET x86_64-pc-windows-msvc)
set(CMAKE_CXX_COMPILER_TARGET x86_64-pc-windows-msvc)

set(CMAKE_EXE_LINKER_FLAGS
    "/libpath:${XWIN_SYSROOT}/sdk/lib/um/x86_64 \
     /libpath:${XWIN_SYSROOT}/sdk/lib/ucrt/x86_64 \
     /libpath:${XWIN_SYSROOT}/crt/lib/x86_64"
)
set(CMAKE_SHARED_LINKER_FLAGS
    "/libpath:${XWIN_SYSROOT}/sdk/lib/um/x86_64 \
     /libpath:${XWIN_SYSROOT}/sdk/lib/ucrt/x86_64 \
     /libpath:${XWIN_SYSROOT}/crt/lib/x86_64"
)