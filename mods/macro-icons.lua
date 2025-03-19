local _G = ShaguTweaks.GetGlobalEnv()
local T = ShaguTweaks.T
local libspell = ShaguTweaks.libspell

local module = ShaguTweaks:register({
  title = T["Macro Icons"],
  description = T["Detect showtooltip and spells in macros to use them on action buttons."],
  expansions = { ["vanilla"] = true, ["tbc"] = false },
  maintainer = "@shagu (GitHub)",
  enabled = nil,
})

module.enable = function(self)
  local gfind = string.gmatch or string.gfind

  local function ButtonMacroScan(bar)
    if not bar:IsVisible() then return end

    local button, icon

    local prefix = bar:GetName()
    prefix = bar == MainMenuBar and "Action" or prefix
    prefix = bar == BonusActionBarFrame and "BonusAction" or prefix

    -- scan all 12 slots in bar
    for slot = 1, 12 do
      button = _G[prefix.."Button"..slot]
      icon = _G[prefix.."Button"..slot.."Icon"]

      if not button then break end
      local macro = GetActionText(ActionButton_GetPagedID(_G[prefix.."Button"..slot]))

      local spellslot = nil
      local booktype = nil

      if macro then
        local name, body, _
        for slot = 1, 36 do -- 36 macro slots
          name, _, body = GetMacroInfo(slot)
          if name == macro then break end
        end

        if name and body then
          local match

          for line in gfind(body, "[^%\n]+") do
            _, _, match = string.find(line, '^#showtooltip (.+)')

            if not match then
              -- add support to specify custom tooltips via:
              --  /run --showtooltip SPELLNAME
              _, _, match = string.find(line, '%-%-showtooltip (.+)')
            end

            if not match then
              _, _, match = string.find(line, '^/cast (.+)')
            end

            if not match then
              _, _, match = string.find(line, '^/pfcast (.+)')
            end

            if not match then
              _, _, match = string.find(line, 'CastSpellByName%(%"(.+)%"%)')
            end

            if match then
              local _, _, spell, rank = string.find(match, '(.+)%((.+)%)')
              spell = spell or match
              button.spellslot, button.booktype = libspell.GetSpellIndex(spell, rank)

              -- overwrite with spell macro texture where possible
              local texture = GetActionTexture(slot)
              if button.spellslot and button.booktype then
                texture = GetSpellTexture(button.spellslot, button.booktype)
              end

              -- update button texture
              if texture and texture ~= icon:GetTexture() then
                icon:SetTexture(texture)
              end
            end
          end
        end
      end
    end
  end

  local bars = {
    MainMenuBar, BonusActionBarFrame, MultiBarRight, MultiBarLeft,
    MultiBarBottomRight, MultiBarBottomLeft
  }

  local macroicons = CreateFrame("Frame", "ShaguTweaksMacroIcons", UIParent)
  macroicons:RegisterEvent("PLAYER_ENTERING_WORLD")
  macroicons:RegisterEvent("ACTIONBAR_SLOT_CHANGED")
  macroicons:RegisterEvent("ACTIONBAR_PAGE_CHANGED")
  macroicons:RegisterEvent("UPDATE_BONUS_ACTIONBAR")
  macroicons:RegisterEvent("ACTIONBAR_SHOWGRID")
  macroicons:SetScript("OnEvent", function()
    for _, bar in pairs(bars) do ButtonMacroScan(bar) end
  end)
end
