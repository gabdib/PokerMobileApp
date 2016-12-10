-----------------------------------------------------------------------------------------
--
-- deck.lua
--
-----------------------------------------------------------------------------------------

local card = require "src.model.card"

local deck = {}
local mtDeck = { __index = deck }

function deck.new(deckData)

	local newDeck = {}

	newDeck.suitNumber = deckData.suitNumber or 4
	newDeck.valueNumber = deckData.valueNumber or 13
	newDeck.index = 1

	local cards = {}

	for suitIndex=1,newDeck.suitNumber do
		for valueIndex=1,newDeck.valueNumber do
			cards[newDeck.index] = card.new({suit=suitIndex, value=valueIndex})
			newDeck.index = newDeck.index + 1
		end
	end

	newDeck.index = newDeck.index - 1
	newDeck.cards = cards

	return setmetatable(newDeck, mtDeck)
end

function deck:getCard()
	
	local card

	if self.index > 0 then
		card = self.cards[self.index]
		self.index = self.index - 1
	end

	return card
end

function deck:shuffle()
	
	self.index = self.suitNumber * self.valueNumber

	local n = #self.cards
	
	while n > 2 do
		local k = math.random(n)
		self.cards[n], self.cards[k] = self.cards[k], self.cards[n]
		n = n - 1
	end

end

return deck
