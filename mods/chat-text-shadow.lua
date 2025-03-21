local _G = ShaguTweaks.GetGlobalEnv()
local T = ShaguTweaks.T
local rgbhex = ShaguTweaks.rgbhex

local module = ShaguTweaks:register({
  title = T["Enable Text Shadow"],
  description = T["Enable text shadow in all chat frames."],
  expansions = { ["vanilla"] = true, ["tbc"] = false },
  category = T["Chat"],
  maintainer = "@shagu (GitHub)",
  enabled = nil,
})

module.enable = function(self)
  for i=1,NUM_CHAT_WINDOWS do
    local font, size = _G["ChatFrame"..i]:GetFont()
    _G["ChatFrame"..i]:SetFont(font, size, "OUTLINE")
  end
end
