-----------------------------------------------------------------------------------------
--
-- pokerbot.lua
--
-----------------------------------------------------------------------------------------

local match = require "src.model.match"

local mtPokerbot = { __index = pokerbot }
local pokerbot = {}

function pokerbot.new(pokerbotData)

    local newPokerbot = {}

    return setmetatable(newPokerbot, mtPokerbot)

end

function pokerbot:playTurn(match)

	-- Nothing to do by default 
end

return pokerbot