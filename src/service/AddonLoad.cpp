#include "AddonLoad.h"

#include "AddonRenderer.h"
#include "../Settings.h"

namespace Addon {
    void Load(AddonAPI* aApi) {
        // Store pointer for easier access
        APIDefs = aApi;

        // Initialize ImGui
        ImGui::SetCurrentContext((ImGuiContext*)APIDefs->ImguiContext); // cast to ImGuiContext*
        ImGui::SetAllocatorFunctions((void* (*)(size_t, void*))APIDefs->ImguiMalloc, (void(*)(void*, void*))APIDefs->ImguiFree); // on imgui 1.80+
        // Initialize API links
        NexusLink = static_cast<NexusLinkData*>(APIDefs->DataLink.Get("DL_NEXUS_LINK"));
        MumbleLink = static_cast<Mumble::Data*>(APIDefs->DataLink.Get("DL_MUMBLE_LINK"));

        // Load Settings
        Settings::Load();

        // Register Renderers
        APIDefs->Renderer.Register(ERenderType_OptionsRender, Renderer::RenderOptions);
        APIDefs->Renderer.Register(ERenderType_PreRender, Renderer::PreRender);
        APIDefs->Renderer.Register(ERenderType_Render, Renderer::Render);
        APIDefs->Renderer.Register(ERenderType_PostRender, Renderer::PostRender);

        APIDefs->Log(ELogLevel_INFO, ADDON_NAME, "<c=#00ff00>CLion Template Addon</c> was loaded.");
    }

    void Unload() {
        // Store Settings
        Settings::Save();

        // Unregister Renderers
        APIDefs->Renderer.Deregister(Renderer::RenderOptions);
        APIDefs->Renderer.Deregister(Renderer::PostRender);
        APIDefs->Renderer.Deregister(Renderer::Render);
        APIDefs->Renderer.Deregister(Renderer::PreRender);

        // Goodbye.
        APIDefs->Log(ELogLevel_DEBUG, ADDON_NAME, "<c=#ff0000>Signing off</c>, it was an honor commander.");
    }
}
