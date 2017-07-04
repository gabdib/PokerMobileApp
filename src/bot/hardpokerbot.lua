-----------------------------------------------------------------------------------------
--
-- hardpokerbot.lua
--
-----------------------------------------------------------------------------------------

local match = require "src.model.match"
local pokerbot = require "src.bot.pokerbot"

local hardpokerbot = {}

local mtHardPokerbot = { __index = hardpokerbot }

function hardpokerbot.new(pokerbotData)

	local newHardPokerbot = {}

	return setmetatable (newHardPokerbot, mtHardPokerbot)

end

function hardpokerbot:playTurn()

end

return hardpokerbot