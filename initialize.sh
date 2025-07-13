# Initialize Git Submodules
git submodule update --init --recursive

# Export Conan recipes
conan export modules/builder/conan/recipes/imgui --version=1.80
conan export modules/builder/conan/recipes/generic --version=v1.2 --name=rcgg-arcdps-api
conan export modules/builder/conan/recipes/generic --version=latest --name=rcgg-mumble-api
conan export modules/builder/conan/recipes/generic --version=v6.1 --name=rcgg-nexus-api

# Install dependencies with the windows profile
conan install . --build=missing --profile modules/builder/conan/profiles/windows