-- Gnomish Treasure Detector - Options UI

local addonName, addonTable = ...

--------------------------------------------------
-- SavedVariables access
--------------------------------------------------
local function GetDB()
    GnomishTreasureDetectorDB = GnomishTreasureDetectorDB or {}
    local db = GnomishTreasureDetectorDB

    if db.enableSound == nil then
        db.enableSound = true
    end

    if db.vignettes == nil then
        db.vignettes = {}
    end

    return db
end

addonTable.GetDB = GetDB

--------------------------------------------------
-- Options panel
--------------------------------------------------
-- Using a simple frame as a category; WoW will parent/position it when the
-- Interface Options panel is opened.
local panel = CreateFrame("Frame", "GnomishTreasureDetectorOptionsPanel")
panel.name = "Gnomish Treasure Detector"

local title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
title:SetPoint("TOPLEFT", 16, -16)
title:SetText("Gnomish Treasure Detector")

local desc = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
desc:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
desc:SetWidth(600)
desc:SetJustifyH("LEFT")
desc:SetText("Configure which vignettes should trigger alerts and whether sound should play.")

--------------------------------------------------
-- Sound toggle
--------------------------------------------------
local soundCheck = CreateFrame("CheckButton", "GTD_EnableSoundCheck", panel, "InterfaceOptionsCheckButtonTemplate")
soundCheck:SetPoint("TOPLEFT", desc, "BOTTOMLEFT", -2, -12)

do
    local textRegion = soundCheck:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    textRegion:SetPoint("LEFT", soundCheck, "RIGHT", 0, 1)
    textRegion:SetText("Enable sound alerts")
    soundCheck.text = textRegion
end

soundCheck:SetScript("OnClick", function(self)
    local db = GetDB()
    db.enableSound = self:GetChecked() and true or false
end)

--------------------------------------------------
-- Vignette list (scrollable, with group headings)
--------------------------------------------------
local scrollFrame = CreateFrame("ScrollFrame", "GTD_VignetteScrollFrame", panel, "UIPanelScrollFrameTemplate")
scrollFrame:SetPoint("TOPLEFT", soundCheck, "BOTTOMLEFT", 0, -16)
scrollFrame:SetSize(600, 320)

local content = CreateFrame("Frame", nil, scrollFrame)
content:SetSize(580, 1)
scrollFrame:SetScrollChild(content)

local vignetteCheckboxes = {}
local vignetteHeaders = {}

local function BuildUIList()
    -- Clear old widgets
    for _, f in ipairs(vignetteCheckboxes) do
        f:Hide()
    end
    for _, f in ipairs(vignetteHeaders) do
        f:Hide()
    end

    local db = GetDB()
    local groups = GTD_VIGNETTE_GROUPS

    if not groups then
        content:SetHeight(1)
        return
    end

    -- Build an ordered list of groups
    local groupKeys = {}
    for key in pairs(groups) do
        table.insert(groupKeys, key)
    end
    table.sort(groupKeys, function(a, b)
        local ga = groups[a]
        local gb = groups[b]
        local na = ga and ga.name or a
        local nb = gb and gb.name or b
        return na < nb
    end)

    local headerIndex = 0
    local checkboxIndex = 0
    local spacing = 20
    local lastWidget

    for _, key in ipairs(groupKeys) do
        local group = groups[key]
        if group and group.entries then
            local groupName = group.name or key

            -- header
            headerIndex = headerIndex + 1
            local header = vignetteHeaders[headerIndex]
            if not header then
                header = content:CreateFontString(nil, "ARTWORK", "GameFontNormal")
                vignetteHeaders[headerIndex] = header
            end

            header:ClearAllPoints()
            if not lastWidget then
                header:SetPoint("TOPLEFT", content, "TOPLEFT", 0, -4)
            else
                header:SetPoint("TOPLEFT", lastWidget, "BOTTOMLEFT", 0, -spacing)
            end
            header:SetText(groupName)
            header:Show()
            lastWidget = header

            -- entries
            local names = {}
            for name in pairs(group.entries) do
                table.insert(names, name)
            end
            table.sort(names)

            for _, name in ipairs(names) do
                local info = group.entries[name]
                checkboxIndex = checkboxIndex + 1
                local check = vignetteCheckboxes[checkboxIndex]

                if not check then
                    check = CreateFrame("CheckButton", nil, content, "InterfaceOptionsCheckButtonTemplate")
                    vignetteCheckboxes[checkboxIndex] = check

                    local textRegion = check:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
                    textRegion:SetPoint("LEFT", check, "RIGHT", 0, 1)
                    check.text = textRegion
                end

                check:ClearAllPoints()
                if lastWidget == header then
                    check:SetPoint("TOPLEFT", header, "BOTTOMLEFT", 4, -4)
                else
                    check:SetPoint("TOPLEFT", lastWidget, "BOTTOMLEFT", 0, -2)
                end

                local defaultEnabled = info and info.defaultEnabled
                if defaultEnabled == nil then
                    defaultEnabled = true
                end

                local userSetting = db.vignettes[name]
                local effectiveEnabled = (userSetting == nil) and defaultEnabled or userSetting

                check:SetChecked(effectiveEnabled)
                check:Show()

                if info and info.note then
                    check.text:SetText(name .. " - " .. info.note)
                else
                    check.text:SetText(name)
                end

                check:SetScript("OnClick", function(self)
                    local db2 = GetDB()
                    db2.vignettes[name] = self:GetChecked() and true or false
                end)

                lastWidget = check
            end
        end
    end

    if lastWidget then
        local totalHeight = math.abs(lastWidget:GetTop() - content:GetTop()) + 40
        content:SetHeight(totalHeight)
    else
        content:SetHeight(1)
    end
end

panel.refresh = function()
    local db = GetDB()
    soundCheck:SetChecked(db.enableSound)
    BuildUIList()
end

InterfaceOptions_AddCategory(panel)

--------------------------------------------------
-- Slash command
--------------------------------------------------
SLASH_GNOMISHTREASUREDETECTOR1 = "/gtd"
SlashCmdList.GNOMISHTREASUREDETECTOR = function()
    if not InterfaceOptionsFrame:IsShown() then
        InterfaceOptionsFrame_Show()
    end
    InterfaceOptionsFrame_OpenToCategory(panel)
    InterfaceOptionsFrame_OpenToCategory(panel) -- called twice to work around Blizzard bug
end
