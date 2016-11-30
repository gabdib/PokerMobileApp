-----------------------------------------------------------------------------------------
--
-- deck.lua
--
-----------------------------------------------------------------------------------------

local card = require("model.card")

local deck = {}
local mtDeck = { __index = deck }

function deck.new(deckData)

	local suitNumber = deckData.suitNumber or 4
	local valueNumber = deckData.valueNumber or 13

	local cards = {}

	for suitIndex=1,suitNumber do
		for valueIndex=1,valueNumber do
			cards[suitIndex..valueIndex] = card.new({suit=suitIndex, value=valueIndex})
		end
	end

	local newDeck = 
	{
		suitNumber = suitNumber,
		valueNumber = valueNumber,
		cards = cards
	}

	return setmetatable(newDeck, mtDeck)
end

function deck:getCard()
	
	if self.valueNumber == 0 then
		self.suitNumber = self.suitNumber - 1
		self.valueNumber = 13
	end

	if self.suitNumber == 0 then
		self.suitNumber = 4
		self.valueNumber = 13
	end

--	local card = self.cards[card.config.suit[self.suitNumber]..self.valueNumber]

	local card = self.cards[self.suitNumber..self.valueNumber]

	print("getCard = "..self.suitNumber..self.valueNumber)

	self.valueNumber = self.valueNumber - 1

	return card
end

return deck
