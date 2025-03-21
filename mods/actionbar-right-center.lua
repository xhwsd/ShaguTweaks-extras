local _G = ShaguTweaks.GetGlobalEnv()
local T = ShaguTweaks.T
local rgbhex = ShaguTweaks.rgbhex

local module = ShaguTweaks:register({
  title = T["Center Vertical Actionbar"],
  description = T["Center the vertical actionbar on the right side."],
  expansions = { ["vanilla"] = true, ["tbc"] = false },
  maintainer = "@shagu (GitHub)",
  enabled = nil,
})

module.enable = function(self)
  MultiBarRight:ClearAllPoints()
  MultiBarRight:SetPoint("RIGHT", 0, -16)
end
