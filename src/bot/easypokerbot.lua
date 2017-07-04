-----------------------------------------------------------------------------------------
--
-- pokerbot.lua
--
-----------------------------------------------------------------------------------------

local match = require "src.model.match"
local pokerbot = require "src.bot.pokerbot"

local easypokerbot = {}
easypokerbot.__index = pokerbot

local mtEasyPokerbot = { __index = easypokerbot }

function easypokerbot.new(pokerbotData)

	local newEasyPokerbot = {}

	return setmetatable (newEasyPokerbot, mtEasyPokerbot)

end

function easypokerbot:playTurn(match, card, cardLevel)

	local handIndex = -1

	if currMatch then 
		--local isPlayerTurn, cardLevel = currMatch:getTurnInformation()

		local insert = false
		while insert == false do

			handIndex = math.random(5)
			local hand = match.rival.hands[handIndex]

			if hand and #(hand.cards) == (cardLevel-1) then
				insert = true
			end
		end
	end

	return handIndex
end

return easypokerbot