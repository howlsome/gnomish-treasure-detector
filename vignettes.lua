-- Gnomish Treasure Detector - Vignette configuration
-- This file is meant to be maintained by the author and advanced users.
-- Add or remove entries as needed.
--
-- Layout:
-- GTD_VIGNETTE_GROUPS = {
--   [groupKey] = {
--     name = "Display Name",
--     entries = {
--       ["Vignette Name"] = {
--         defaultEnabled = true/false,
--         note = "Optional description",
--       },
--     },
--   },
-- }

GTD_VIGNETTE_GROUPS = {

    ----------------------------------------------------------------
    -- Warlords of Draenor
    ----------------------------------------------------------------
    WOD_GARRISON = {
        name = "Warlords of Draenor - Garrison",
        entries = {
            ["Garrison Cache"] = {
                defaultEnabled = false,
                note = "Garrison Cache",
            },
            ["Full Garrison Cache"] = {
                defaultEnabled = false,
                note = "Full Garrison Cache",
            },
        },
    },

    ----------------------------------------------------------------
    -- Dragonflight - Open World / Utility NPCs
    ----------------------------------------------------------------
    DF_NPCS = {
        name = "Dragonflight - Utility NPCs",
        entries = {
            ["Rostrum of Transformation"] = {
                defaultEnabled = false,
                note = "Dragonflight Rostrum of Transformation",
            },
            ["Renown Quartermaster"] = {
                defaultEnabled = false,
                note = "Dragonflight Renown Quartermaster",
            },
            ["Bronze Timekeeper"] = {
                defaultEnabled = false,
                note = "Dragonflight Bronze Timekeeper",
            },
        },
    },

    ----------------------------------------------------------------
    -- The War Within - Hallowfall Keyflames
    ----------------------------------------------------------------
    TWW_KEYFLAMES = {
        name = "The War Within - Hallowfall Keyflames",
        entries = {
            ["Bleak Sand Keyflame"] = {
                defaultEnabled = false,
                note = "Hallowfall Keyflame",
            },
            ["Duskrise Acreage Keyflame"] = {
                defaultEnabled = false,
                note = "Hallowfall Keyflame",
            },
            ["Fungal Field Keyflame"] = {
                defaultEnabled = false,
                note = "Hallowfall Keyflame",
            },
            ["Light's Blooming Keyflame"] = {
                defaultEnabled = false,
                note = "Hallowfall Keyflame",
            },
            ["Stillstone Pond Keyflame"] = {
                defaultEnabled = false,
                note = "Hallowfall Keyflame",
            },
            ["The Faded Shore Keyflame"] = {
                defaultEnabled = false,
                note = "Hallowfall Keyflame",
            },
            ["The Whirring Field Keyflame"] = {
                defaultEnabled = false,
                note = "Hallowfall Keyflame",
            },
            ["Torchlight Mine Keyflame"] = {
                defaultEnabled = false,
                note = "Hallowfall Keyflame",
            },
        },
    },

    ----------------------------------------------------------------
    -- The War Within - Delves / Companions
    ----------------------------------------------------------------
    TWW_DELVES = {
        name = "The War Within - Delves",
        entries = {
            ["Brann Bronzebeard"] = {
                defaultEnabled = false,
                note = "Delves companion",
            },
        },
    },

    ----------------------------------------------------------------
    -- Midnight - placeholder group
    -- Add new Midnight service NPCs / vignettes here as you discover them.
    ----------------------------------------------------------------
    MIDNIGHT_UTILITY = {
        name = "Midnight - Utility / Service",
        entries = {
            -- Example placeholders (fill in with actual names as they appear):
            -- ["Some Midnight Service NPC"] = {
            --     defaultEnabled = false,
            --     note = "Midnight hub/service NPC",
            -- },
        },
    },

    ----------------------------------------------------------------
    -- Example group for rares/treasures you *want* to be on by default
    ----------------------------------------------------------------
    GENERIC_RARES = {
        name = "Generic Rares / Treasures",
        entries = {
            -- ["Some Rare Name"] = {
            --     defaultEnabled = true,
            --     note = "Example rare that we DO want alerts for",
            -- },
        },
    },
}

----------------------------------------------------------------
-- Helper: flattened lookup table for fast access in core.lua
----------------------------------------------------------------
GTD_VIGNETTES = {}

do
    for _, groupData in pairs(GTD_VIGNETTE_GROUPS) do
        local entries = groupData.entries
        if entries then
            for name, info in pairs(entries) do
                GTD_VIGNETTES[name] = info
            end
        end
    end
end
