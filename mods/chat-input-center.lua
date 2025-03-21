local _G = ShaguTweaks.GetGlobalEnv()
local T = ShaguTweaks.T
local rgbhex = ShaguTweaks.rgbhex

local module = ShaguTweaks:register({
  title = T["Center Text Input Box"],
  description = T["Move the chat input box to the center of the screen."],
  expansions = { ["vanilla"] = true, ["tbc"] = false },
  category = T["Chat"],
  maintainer = "@shagu (GitHub)",
  enabled = nil,
})

local dodge_frames = {
  MainMenuBarArtFrame, MultiBarBottomLeft, MultiBarBottomRight, PetActionBarFrame, ShapeshiftBarFrame
}

module.enable = function(self)
  ChatFrameEditBox:ClearAllPoints()
  ChatFrameEditBox:SetWidth(300)

  -- reload custom frame positions after original frame manage runs
  local hookUIParent_ManageFramePositions = UIParent_ManageFramePositions
  UIParent_ManageFramePositions = function(a1, a2, a3)
    -- run original function
    hookUIParent_ManageFramePositions(a1, a2, a3)

    -- let inputbox dodge certain frames
    local top = 0
    for id, frame in pairs(dodge_frames) do
      if frame:IsVisible() and frame:GetTop() then
        top = math.max(top, frame:GetTop())
      end
    end

    -- set new position
    ChatFrameEditBox:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, top)
  end
end
