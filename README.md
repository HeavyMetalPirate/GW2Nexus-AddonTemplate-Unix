# GW2Nexus-AddonTemplate-Unix
Addon Template for GW2 Nexus. 
This template is designed to be used with CLion, uses CMake as build system and Conan for dependency management.

# Requirements
The following tools need to be installed and/or present on your system:
- cmake
- clang
- lld
- llvm
- conan
- xwin

# Initializing the project
Before opening the project in CLion, conan should be initialized properly to give you the required targets.
This can be done by running the `initialize.sh` script in the root directory of the project.

Running this script will:
- initialize all submodules included in the project
- install all conan dependencies
- generate the CMake files for the conan-release target

After successfully running the script, you should see a `build/Release` directory in the root folder of the project.
Seeing that means everything is initialized for you to work with CLion.

### Note about Conan profiles the WinSDK
The Conan profiles included are optimized for building with a Docker image. While you can technically use them *as is*, 
it is highly recommended to create profiles tailored to your system and environment. This becomes especially apparent with the WinSDK.

By default, the profile used in the `initialize.sh` script expects the WinSDK at the location `/xwin`.
Under this location are expected the directories `sdk` and `crt`.

If you have installed it in a different location, you have two options:
- link the WinSDK to `/xwin` (e.g. `ln -s /path/to/win-sdk /xwin`)
- copy the profiles under `modules/builder/conan/profiles` to your conan profile directory (usually `~/.conan/profiles`) and adjust the `xwin` path in `windows-common` to point to your WinSDK location.

If you opt to copy the profiles, you should modify the `initialize.sh` script to use those copied profiles instead.

# CLion Setup
Under `Settings -> Build, Execution, Deployment -> CMake` you should now see the preset profile `conan-release` (or `conan-debug` in the case of a debug profile).
Make sure to enable it, and you should be able to `Reload CMake Project` without any issues, and subsequently also be able to build the project.

### Note about building a debug build
The profiles included in this project are optimized for release builds. If you want to build for debug configurations, copy the profile `windows-common` under
`modules/builder/conan/profiles` to your conan profile directory if you haven't already, 
and create a new profile `windows-debug` with the following content:

```ini
include(windows-common)

[settings]
build_type=Debug
compiler.runtime_type=Debug
compiler.runtime=static
```

Afterwards, run `conan install . --build=missing --profile windows-debug` to generate the debug build files.
You should now have a preset `conan-debug` available in CLion. Remember to enable it to be able to use it.

# Starting development
After successfully initializing the project and setting up CLion, you can start developing your addon.
The main source files are located in the `src` directory, resources such as images and fonts in the `resources` directory.

`entry.cpp` is the entry point being used by Nexus to load your addon. It features an entry point to grab a reference to your module,
as well as the Nexus Addon definition in the function `extern "C" __declspec(dllexport) AddonDefinition* GetAddonDef()`.
Make sure to adjust the properties to your needs, such as name, description, author and update provider. Also make sure to use a unique negative number for the id.

In the `service` directory you can find the functions to load and unload the addon inside `AddonLoad.*` as well as basic rendering inside `AddonRenderer.*`.
These are just simple examples to get you started. Modify and extend them to suit your needs. If your addon does not render with ImGui you can also remove the `AddonRenderer`.

For further information on how to use the Nexus API, please refer to the Nexus documentation or ask in the Nexus Discord server.

# Building the addon
To build the addon, you can use the CLion build system. Make sure to select the correct CMake profile (either `conan-release` or `conan-debug`) depending on your needs.

An optional Dockerimage is also provided to build the addon in a clean environment or a CD/CI pipeline. An easy way to build the addon using
Docker is to run either `build-docker.sh` or `build-podman.sh` depending on your container runtime of choice. The outputs will go to the `out/` directory.
It will contain both the release and debug build.

# Final words
Make sure to edit this README to describe your addon and its features before releasing the addon.
