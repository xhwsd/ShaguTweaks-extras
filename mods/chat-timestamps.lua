local _G = ShaguTweaks.GetGlobalEnv()
local T = ShaguTweaks.T
local rgbhex = ShaguTweaks.rgbhex

local module = ShaguTweaks:register({
  title = T["Chat Timestamps"],
  description = T["Add timestamps to chat messages."],
  expansions = { ["vanilla"] = true, ["tbc"] = false },
  category = T["Chat"],
  maintainer = "@shagu (GitHub)",
  enabled = false,
  config = {
    ["chat.timestamp.bracket"] = "[]",
    ["chat.timestamp.format"] = 24,
    ["chat.timestamp.color"] = { r = .8, g = .8, b = .8, a = 1},
  }
})

module.enable = function(self)
    -- config shortcuts
    local bracket = self.config["chat.timestamp.bracket"]
    local clock = self.config["chat.timestamp.format"]
    local rgb = self.config["chat.timestamp.color"]

    -- parse config
    local left = string.sub(bracket, 1, 1) or ""
    local right = string.sub(bracket, 2, 2) or ""
    local format = clock == 24 and "%H:%M:%S" or "%I:%M:%S %p"
    local color = rgbhex({ rgb.r, rgb.g, rgb.b, rgb.a })

    -- add hooks to each frame
    for i=1,NUM_CHAT_WINDOWS do
      local original = _G["ChatFrame"..i].AddMessage
      _G["ChatFrame"..i].AddMessage = function(frame, msg, a1, a2, a3, a4, a5)
        -- ignore empty messages
        if not msg then return end

        -- add timestamp to chat
        msg = color .. left .. date(format) .. right .. "|r " .. msg
        original(frame, msg, a1, a2, a3, a4, a5)
      end
    end
end
