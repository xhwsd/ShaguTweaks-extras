local T = ShaguTweaks.T

local module = ShaguTweaks:register({
  title = T["Show Energy Ticks"],
  description = T["Show energy and mana ticks on the player unit frame."],
  expansions = { ["vanilla"] = true, ["tbc"] = nil },
  maintainer = "@shagu (GitHub)",
  enabled = nil,
})

module.enable = function(self)
  local energytick = CreateFrame("Frame", nil, PlayerFrameManaBar)
  energytick:SetAllPoints(PlayerFrameManaBar)
  energytick:RegisterEvent("PLAYER_ENTERING_WORLD")
  energytick:RegisterEvent("UNIT_DISPLAYPOWER")
  energytick:RegisterEvent("UNIT_ENERGY")
  energytick:RegisterEvent("UNIT_MANA")
  energytick:SetScript("OnEvent", function()
    if UnitPowerType("player") == 0 then
      this.mode = "MANA"
      this:Show()
    elseif UnitPowerType("player") == 3 then
      this.mode = "ENERGY"
      this:Show()
    else
      this:Hide()
    end

    if event == "PLAYER_ENTERING_WORLD" then
      this.lastMana = UnitMana("player")
    end

    if (event == "UNIT_MANA" or event == "UNIT_ENERGY") and arg1 == "player" then
      this.currentMana = UnitMana("player")
      local diff = 0
      if this.lastMana then
        diff = this.currentMana - this.lastMana
      end

      if this.mode == "MANA" and diff < 0 then
        this.target = 5
      elseif this.mode == "MANA" and diff > 0 then
        if this.max ~= 5 and diff > (this.badtick and this.badtick*1.2 or 5) then
          this.target = 2
        else
          this.badtick = diff
        end
      elseif this.mode == "ENERGY" and diff > 0 then
        this.target = 2
      end
      this.lastMana = this.currentMana
    end
  end)

  energytick:SetScript("OnUpdate", function()
    if this.target then
      this.start, this.max = GetTime(), this.target
      this.target = nil
    end

    if not this.start then return end

    this.current = GetTime() - this.start

    if this.current > this.max then
      this.start, this.max, this.current = GetTime(), 2, 0
    end

    local pos = 120 * (this.current / this.max)
    this.spark:SetPoint("LEFT", pos - 8.5, 0)
  end)

  energytick.spark = energytick:CreateTexture(nil, 'OVERLAY')
  energytick.spark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
  energytick.spark:SetHeight(27)
  energytick.spark:SetWidth(17)
  energytick.spark:SetBlendMode('ADD')
end
