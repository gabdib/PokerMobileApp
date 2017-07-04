-----------------------------------------------------------------------------------------
--
-- pokerbot.lua
--
-----------------------------------------------------------------------------------------

local match = require "src.model.match"
local pokerbot = require "src.bot.pokerbot"

local mediumpokerbot = {}

local mtMediumPokerbot = { __index = mediumpokerbot }

function mediumpokerbot.new(pokerbotData)

	local newMediumPokerbot = {}

	return setmetatable (newMediumPokerbot, mtMediumPokerbot)

end

function mediumpokerbot:playTurn()
end

return mediumpokerbot