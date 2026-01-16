-- Gnomish Treasure Detector - core
-- Alerts the user to nearby rares or treasures to collect

local addonName, addonTable = ...

--------------------------------------------------
-- SavedVariables access
--------------------------------------------------
local function GetDB()
    if addonTable and addonTable.GetDB then
        return addonTable.GetDB()
    end

    -- Fallback if options.lua hasn't run for some reason
    GnomishTreasureDetectorDB = GnomishTreasureDetectorDB or {
        enableSound = true,
        vignettes = {},
    }
    return GnomishTreasureDetectorDB
end

--------------------------------------------------
-- Vignette enable check
--------------------------------------------------
local function IsVignetteEnabled(name)
    if not name then
        -- If we can't identify it, err on the side of showing it.
        return true
    end

    local db = GetDB()
    local cfg = GTD_VIGNETTES and GTD_VIGNETTES[name]

    local defaultEnabled = true
    if cfg and cfg.defaultEnabled ~= nil then
        defaultEnabled = cfg.defaultEnabled and true or false
    end

    local userSetting = db.vignettes and db.vignettes[name]
    if userSetting ~= nil then
        return userSetting and true or false
    end

    return defaultEnabled
end

--------------------------------------------------
-- Event handler
--------------------------------------------------
local function OnVignetteAdded(self, event, id)
    if not id then
        return
    end

    self.vignettes = self.vignettes or {}
    if self.vignettes[id] then
        return
    end

    local vignetteInfo = C_VignetteInfo and C_VignetteInfo.GetVignetteInfo and C_VignetteInfo.GetVignetteInfo(id)
    if not vignetteInfo then
        return
    end

    if not IsVignetteEnabled(vignetteInfo.name) then
        return
    end

    if not vignetteInfo.atlasName then
        return
    end

    local atlasInfo = C_Texture and C_Texture.GetAtlasInfo and C_Texture.GetAtlasInfo(vignetteInfo.atlasName)
    if not atlasInfo then
        return
    end

    local left = (atlasInfo.leftTexCoord or 0) * 256
    local right = (atlasInfo.rightTexCoord or 0) * 256
    local top = (atlasInfo.topTexCoord or 0) * 256
    local bottom = (atlasInfo.bottomTexCoord or 0) * 256

    local icon = "|TInterface\\MINIMAP\\ObjectIconsAtlas:0:0:0:0:256:256:" ..
        left .. ":" .. right .. ":" .. top .. ":" .. bottom .. "|t"

    local nameText = vignetteInfo.name or "Unknown"
    local message = icon .. " " .. nameText .. " spotted!"

    local db = GetDB()

    if RaidWarningFrame and RaidNotice_AddMessage and ChatTypeInfo and ChatTypeInfo.RAID_WARNING then
        RaidNotice_AddMessage(RaidWarningFrame, message, ChatTypeInfo.RAID_WARNING)
    end

    if db.enableSound and PlaySoundFile then
        -- Using numeric sound ID is safe.
        PlaySoundFile(567397)
    end

    print(icon, nameText, "spotted!")

    self.vignettes[id] = true
end

--------------------------------------------------
-- Init
--------------------------------------------------
local eventHandler = CreateFrame("Frame")
eventHandler:RegisterEvent("VIGNETTE_MINIMAP_UPDATED")
eventHandler:SetScript("OnEvent", OnVignetteAdded)
