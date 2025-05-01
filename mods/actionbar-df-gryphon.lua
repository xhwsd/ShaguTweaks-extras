local _G = ShaguTweaks.GetGlobalEnv()
local T = ShaguTweaks.T

local module = ShaguTweaks:register({
  title = T["Dragonflight Gryphons"],
  description = T["Replaces actionbar gryphons with the dragonflight version."],
  expansions = { ["vanilla"] = true, ["tbc"] = false },
  maintainer = "@shagu (GitHub)",
  enabled = nil,
})

module.enable = function(self)
  -- replace original gryphons by dragonflight versions
  MainMenuBarLeftEndCap:SetTexture("Interface\\AddOns\\ShaguTweaks-extras\\img\\df-gryphon")
  MainMenuBarRightEndCap:SetTexture("Interface\\AddOns\\ShaguTweaks-extras\\img\\df-gryphon")
end
