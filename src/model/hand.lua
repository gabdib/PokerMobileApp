-----------------------------------------------------------------------------------------
--
-- hand.lua
--
-----------------------------------------------------------------------------------------

local card = require "src.model.card"

local hand = {}
local mtHand = { __index = hand}

hand.config =
{
	size = 5
}

function hand.new(handData)

	local newHand = {}

	local index = handData.index or 1
	local cards = handData.cards or {}

	newHand.index = index
	newHand.cards = cards

	return setmetatable(newHand, mtHand)
end

function hand:reset()
	self.index = 1
	self.cards = {}
end

function hand:size()
	return #(self.cards)
end

function hand:addCard(card)

	local result = false
	
	if card.suit and card.value and self.index < hand.config.size then 
		self.cards[self.index] = card
		self.index = self.index + 1
		result = true
	end

	return result
end

return hand