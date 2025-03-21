local _G = ShaguTweaks.GetGlobalEnv()
local T = ShaguTweaks.T
local rgbhex = ShaguTweaks.rgbhex

local module = ShaguTweaks:register({
  title = T["Chat History"],
  description = T["Save chat history of all non-combatlog windows and restore it on login."],
  expansions = { ["vanilla"] = true, ["tbc"] = false },
  category = T["Chat"],
  maintainer = "@shagu (GitHub)",
  enabled = nil,
})

module.enable = function(self)
  local realm = GetRealmName()
  local player = UnitName("player")

  local history
  local function SaveChatHistory(id, msg, r, g, b)
    -- create cache tables if not existing
    ShaguTweaks_cache = ShaguTweaks_cache or {}
    ShaguTweaks_cache["chathistory"] = ShaguTweaks_cache["chathistory"] or {}
    ShaguTweaks_cache["chathistory"][realm] = ShaguTweaks_cache["chathistory"][realm] or {}
    ShaguTweaks_cache["chathistory"][realm][player] = ShaguTweaks_cache["chathistory"][realm][player] or {}
    ShaguTweaks_cache["chathistory"][realm][player][id] = ShaguTweaks_cache["chathistory"][realm][player][id] or {}

    if r and g and b then
      local color = rgbhex(r*.5+.2, g*.5+.2, b*.5+.2)
      msg = string.gsub(msg, "^", color)
      msg = string.gsub(msg, "|r", "|r" .. color)
    end

    history = ShaguTweaks_cache["chathistory"][realm][player][id]
    table.insert(history, 1, msg)
    if history[30] then table.remove(history, 30) end
  end

  local function GetChatHistory(id)
    -- create cache tables if not existing
    ShaguTweaks_cache = ShaguTweaks_cache or {}
    ShaguTweaks_cache["chathistory"] = ShaguTweaks_cache["chathistory"] or {}
    ShaguTweaks_cache["chathistory"][realm] = ShaguTweaks_cache["chathistory"][realm] or {}
    ShaguTweaks_cache["chathistory"][realm][player] = ShaguTweaks_cache["chathistory"][realm][player] or {}
    ShaguTweaks_cache["chathistory"][realm][player][id] = ShaguTweaks_cache["chathistory"][realm][player][id] or {}

    return ShaguTweaks_cache["chathistory"][realm][player][id]
  end

  local function AddMessage(frame, text, a1, a2, a3, a4, a5)
    if not text then return end

    -- save chat history
    SaveChatHistory(frame:GetID(), text, a1, a2, a3)
    frame:ShaguTweaksChatHistoryAddMessage(text, a1, a2, a3, a4, a5)
  end

  for i=1,NUM_CHAT_WINDOWS do
    -- detect combat log message groups
    local combat = 0
    for _, msg in pairs(_G["ChatFrame"..i].messageTypeList) do
      if strfind(msg, "SPELL", 1) or strfind(msg, "COMBAT", 1) then
        combat = combat + 1
      end
    end

    -- apply hooks and restore history on non-combat log frames
    if combat <= 5 and not _G["ChatFrame"..i].ShaguTweaksChatHistoryAddMessage then
      -- write history to chat
      local history = GetChatHistory(i)
      for j=30,0,-1 do
        if history[j] then
          _G["ChatFrame"..i]:AddMessage(history[j], .7,.7,.7)
        end
      end

      -- add chat history hooks
      _G["ChatFrame"..i].ShaguTweaksChatHistoryAddMessage = _G["ChatFrame"..i].AddMessage
      _G["ChatFrame"..i].AddMessage = AddMessage
    end
  end
end
