local _G = ShaguTweaks.GetGlobalEnv()
local T = ShaguTweaks.T

local module = ShaguTweaks:register({
  title = T["Dragonflight Gryphons"],
  description = T["Replaces actionbar gryphons with the dragonflight version."],
  expansions = { ["vanilla"] = true, ["tbc"] = false },
  maintainer = "@shagu (GitHub)",
  category = T["Action Bar"],
  config = {
    ["dragonfly.gryphon"] = "retail",
  },
  enabled = nil,
})

module.enable = function(self)
  local gryphon = CreateFrame("Frame", nil, MainMenuBarArtFrame)
  gryphon:SetFrameStrata("HIGH")
  gryphon:RegisterEvent("PLAYER_ENTERING_WORLD")
  gryphon:SetScript("OnEvent", function()
    -- replace original gryphons by dragonflight versions
    if module.config["dragonfly.gryphon"] == "beta" then
      -- artwork during beta
      MainMenuBarLeftEndCap:SetTexture("Interface\\AddOns\\ShaguTweaks-extras\\img\\df-gryphon-beta")
      MainMenuBarRightEndCap:SetTexture("Interface\\AddOns\\ShaguTweaks-extras\\img\\df-gryphon-beta")
    elseif UnitFactionGroup("player") == "Horde" then
      -- retail horde
      MainMenuBarLeftEndCap:SetTexture("Interface\\AddOns\\ShaguTweaks-extras\\img\\df-wyvern")
      MainMenuBarRightEndCap:SetTexture("Interface\\AddOns\\ShaguTweaks-extras\\img\\df-wyvern")
    else
      -- retail alliance
      MainMenuBarLeftEndCap:SetTexture("Interface\\AddOns\\ShaguTweaks-extras\\img\\df-gryphon")
      MainMenuBarRightEndCap:SetTexture("Interface\\AddOns\\ShaguTweaks-extras\\img\\df-gryphon")
    end

    -- move gryphons above action buttons
    MainMenuBarLeftEndCap:SetParent(this)
    MainMenuBarRightEndCap:SetParent(this)
  end)
end
