#include <locale>
#include "Globals.h"
#include "service/AddonLoad.h"

///----------------------------------------------------------------------------------------------------
/// DllMain:
/// 	Main entry point for DLL.
/// 	We are not interested in this, all we get is our own HMODULE in case we need it.
///----------------------------------------------------------------------------------------------------
BOOL APIENTRY DllMain(HMODULE hModule, DWORD  ul_reason_for_call, LPVOID lpReserved)
{
    switch (ul_reason_for_call)
    {
        case DLL_PROCESS_ATTACH:
            hSelf = hModule; break;
        case DLL_PROCESS_DETACH:
        case DLL_THREAD_ATTACH:
        case DLL_THREAD_DETACH:
        default:
            // NO OPs
            break;
    }
    return TRUE;
}

///----------------------------------------------------------------------------------------------------
/// GetAddonDef:
/// 	Export needed to give Nexus information about the addon.
///----------------------------------------------------------------------------------------------------
extern "C" __declspec(dllexport) AddonDefinition* GetAddonDef()
{
    AddonDef.Signature = -123456789; // set to random unused negative integer
    AddonDef.APIVersion = NEXUS_API_VERSION;
    AddonDef.Name = "CLion Template Addon";
    AddonDef.Version.Major = 0;
    AddonDef.Version.Minor = 0;
    AddonDef.Version.Build = 0;
    AddonDef.Version.Revision = 1;
    AddonDef.Author = "Nexus Addon Developer";
    AddonDef.Description = "Sample addon to get you started with CLion and the Nexus API.";
    AddonDef.Load = Addon::Load;
    AddonDef.Unload = Addon::Unload;
    AddonDef.Flags = EAddonFlags_None;

    /* not necessary if hosted on Raidcore, but shown anyway for the example also useful as a backup resource */
    AddonDef.Provider = EUpdateProvider_None;
    //AddonDef.UpdateLink = "https://github.com/<your-github-username>/<your-addon-repo>";

    return &AddonDef;
}
