local _G = ShaguTweaks.GetGlobalEnv()
local T = ShaguTweaks.T

local module = ShaguTweaks:register({
  title = T["Show Micro Menu"],
  description = T["Shows micro menu buttons when using the reduced actionbar layout. Hold Ctrl+Shift to move the micro menu."],
  expansions = { ["vanilla"] = true, ["tbc"] = nil },
  category = T["Reduced Actionbar Size"],
  maintainer = "@shagu (GitHub)",
  enabled = nil,
})

module.enable = function(self)
  -- only run if reduced actionbar is enabled
  if ShaguTweaks_config[T["Reduced Actionbar Size"]] == 0 then return end

  local frames = {
    CharacterMicroButton, SpellbookMicroButton, TalentMicroButton,
    QuestLogMicroButton, MainMenuMicroButton, SocialsMicroButton,
    WorldMapMicroButton, HelpMicroButton
  }

  local microframe = CreateFrame("Button", "ShaguTweaksReducedActionBarMicroMenu", UIParent)
  microframe:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -8, 8)
  microframe:SetWidth(225)
  microframe:SetHeight(44)

  microframe:SetFrameStrata("MEDIUM")
  microframe:SetBackdrop({
    bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true, tileSize = 8, edgeSize = 16,
    insets = { left = 3, right = 3, top = 3, bottom = 3 }
  })

  microframe:SetBackdropBorderColor(.9,.8,.5,1)
  microframe:SetBackdropColor(.4,.4,.4,1)

  microframe:SetClampedToScreen(true)
  microframe:SetMovable(true)
  microframe:EnableMouse(true)
  microframe:RegisterForDrag("LeftButton")

  microframe:SetUserPlaced(true)

  microframe:RegisterEvent("PLAYER_ENTERING_WORLD")

  microframe:SetScript("OnDragStart", function()
    if not IsShiftKeyDown() or not IsControlKeyDown() then return end
    this:StartMoving()
  end)

  microframe:SetScript("OnDragStop", function()
    this:StopMovingOrSizing()
  end)

  microframe:SetScript("OnUpdate", function()
    if MouseIsOver(this) and IsShiftKeyDown() and IsControlKeyDown() then
      if not this.mousedisabled then
        -- disable mouse events on all frames
        this.mousedisabled = true
        for _, frame in pairs(frames) do
          frame:EnableMouse(0)
        end
      end
    else
      if this.mousedisabled then
        -- enable all mouse events again
        this.mousedisabled = false
        for _, frame in pairs(frames) do
          frame:EnableMouse(1)
        end
      end
    end
  end)

  microframe:SetScript("OnEvent", function()
    ShaguTweaks.DarkenFrame(microframe)

    for id, frame in pairs(frames) do
      local anchor = frames[id-1] or microframe
      frame:SetPoint("LEFT", anchor, id == 1 and "LEFT" or "RIGHT", id == 1 and 3.5 or -2, id==1 and 10 or 0)
      frame:SetParent(microframe)
      frame.Show = frame:Show()
      frame:Show()
    end
  end)
end
