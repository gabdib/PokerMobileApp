-----------------------------------------------------------------------------------------
--
-- hand.lua
--
-----------------------------------------------------------------------------------------

local card = require "src.model.card"
local ranking = require "src.model.ranking"

local hand = {}
local mtHand = { __index = hand}

hand.config =
{
	size = 5,

	ranking = 
	{
		"High card",
		"One Pair",
		"Two Pair",
		"Three of a kind",
		"Straight",
		"Flush",
		"Full house",
		"Four of a kind",
		"Straight flush",
		"Royal flush",

		highCard = 1,
		onePair = 2,
		twoPair = 3,
		threeOfAKind = 4,
		straight = 5,
		flush = 6,
		fullHouse =7,
		fourOfAKind = 8,
		straightFlush = 9,
		royalFlush = 10
	}
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
	
	if card.suit and card.value and self.index <= hand.config.size then 
		self.cards[self.index] = card
		self.index = self.index + 1
		result = true
	end

	return result
end

function hand:checkRanking()

	local result = {}

	local valueWeights = self:getValueWeights()

	local flushResult = self:getFlushRanking()
	local straightResult = self:getStraightRanking(valueWeights)
	local kindResult = self:getKindRanking(valueWeights)

	if flushResult.ranking == hand.config.ranking.flush and straightResult.ranking == hand.config.ranking.straight then
		
		if flushResult.value == card.config.value[1] then
			return {ranking = hand.config.ranking.royalFlush, value = flushResult.value}
		else
			return {ranking = hand.config.ranking.straightFlush, value = straightResult.value}
		end

	elseif flushResult.ranking == 0 and straightResult == hand.config.ranking.straight then

		return straightResult

	elseif flushResult.ranking == hand.config.ranking.flush and straightResult == o then 
		
		if kindResult == hand.config.ranking.fullHouse then
			return kindResult
		else
			return straightResult
		end
	else

		return kindResult
	end

	return ranking 
end

function hand:getValueWeights()

	local weights = {}

	for i=1,#(card.config.value) do weights[i] = 0 end

	for kCard,vCard in ipairs(self.cards) do weights[vCard.value] = weights[vCard.value] + 1 end

	-- print("Value Weights: ") for k,v in ipairs(weights) do print(k,v) end

	return weights

end

function hand:getFlushRanking()

	local currentSuit = self.cards[1].suit
	local value = 0

	for kCard,vCard in ipairs(self.cards) do

		if currentSuit == vCard.suit then

			if value < vCard.value then value = vCard.value end

		else
			return {ranking = 0, value = 0}
		end
	end

	return {ranking = hand.config.ranking.flush, value = value}

end

function hand:getStraightRanking(weights)

	local value = 0
	local counter = 0

	local iWeight = 0
	for iValue = #weights, 1, -1 do

		iWeight = weights[iValue]
		if iWeight == 1 then
			
			counter = counter + 1

			if value < iValue then value = iValue end

			if counter == hand.config.size then
				return {ranking = hand.config.ranking.straight, value = value}
			end

		elseif iWeight == 0 then

			counter = 0

		else
			return {ranking = 0, value = 0}
		end
	end

	return {ranking = 0, value = 0}
end

function hand:getKindRanking(weights)

	local result = {ranking = hand.config.ranking.highCard, value = 0}

	local totalWeight = 0

	for value,weight in ipairs(weights) do

		if weight == 4 then
			
			result.ranking = hand.config.ranking.fourOfAKind
			result.value = value
		
		elseif weight == 3 then

			if result.ranking == hand.config.ranking.onePair then
				result.ranking = hand.config.ranking.fullHouse
			else 
				result.ranking = hand.config.ranking.threeOfAKind
			end

			result.value = value

		elseif weight == 2 then

			if result.ranking == hand.config.ranking.threeOfAKind then
				
				result.ranking = hand.config.ranking.fullHouse
			
			elseif result.ranking == hand.config.ranking.onePair then
				
				result.ranking = hand.config.ranking.twoPair
				if result.value < value then result.value = value end

			else
				result.ranking = hand.config.ranking.onePair
				result.value = value
			end
		else
			if result.ranking == hand.config.ranking.highCard and result.value < value then
				result.value = value
			end
		end
		
		totalWeight = totalWeight + weight
		if totalWeight == 5  then break end

	end

	return result
end

return hand