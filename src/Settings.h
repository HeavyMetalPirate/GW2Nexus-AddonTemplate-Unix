#ifndef SETTINGS_H
#define SETTINGS_H

#include "Globals.h"
#include <string>
#include <nlohmann/json.hpp>
using json = nlohmann::json;

namespace Settings
{

    struct AddonSettings_t
    {
        bool flag;
        std::string text;
        int number;
    };
    NLOHMANN_DEFINE_TYPE_NON_INTRUSIVE_WITH_DEFAULT(AddonSettings_t, flag, text, number);

    void Load();

    void Save();
}

extern Settings::AddonSettings_t AddonSettings;

#endif //SETTINGS_H
