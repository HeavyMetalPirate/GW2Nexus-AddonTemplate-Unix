#ifndef GLOBALS_H
#define GLOBALS_H

#include "Constants.h"

#include <Nexus.h>
#include <Mumble.h>
#include <imgui.h>

#include "../resources/resources.h"

#include <filesystem>

extern HMODULE hSelf;

extern AddonDefinition AddonDef;
extern AddonAPI* APIDefs;
extern Mumble::Data* MumbleLink;
extern NexusLinkData* NexusLink;

extern std::filesystem::path AddonPath;

#endif //GLOBALS_H
