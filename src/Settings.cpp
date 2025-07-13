#include "Settings.h"
#include "Constants.h"
#include <filesystem>
#include <fstream>

namespace fs = std::filesystem;

// Initialize AddonSettings with default values
Settings::AddonSettings_t AddonSettings = {
    .flag = true,
    .text = "Hello, Nexus!",
    .number = 42
};

inline std::string getAddonFolder() {
    std::string pathFolder = APIDefs->Paths.GetAddonDirectory(ADDON_NAME);
    // Create folder if not exist
    if (!fs::exists(pathFolder)) {
        try {
            fs::create_directory(pathFolder);
        }
        catch (const std::exception& e) {
            std::string message = "Could not create addon directory: ";
            message.append(pathFolder);
            APIDefs->Log(ELogLevel::ELogLevel_CRITICAL, ADDON_NAME, message.c_str());

            // Suppress the warning for the unused variable 'e'
#pragma warning(suppress: 4101)
            e;
        }
    }
    return pathFolder;
}

void Settings::Load()
{
    if (const std::string pathData = getAddonFolder() + "/settings.json"; fs::exists(pathData))
    {
        if (std::ifstream dataFile(pathData); dataFile.is_open())
        {
            json jsonData;
            dataFile >> jsonData;
            dataFile.close();
            // parse settings, yay
            AddonSettings = jsonData;
        }
    }
}

void Settings::Save()
{
    const json j = AddonSettings;

    const std::string pathData = getAddonFolder() + "/settings.json";
    if (std::ofstream outputFile(pathData); outputFile.is_open()) {
        outputFile << j.dump(4) << std::endl;
        outputFile.close();
    }
    else {
        APIDefs->Log(ELogLevel_WARNING, ADDON_NAME, "Could not store settings.json - configuration might get lost between loads.");
    }
}