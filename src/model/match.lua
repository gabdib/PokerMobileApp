-----------------------------------------------------------------------------------------
--
-- match.lua
--
-----------------------------------------------------------------------------------------

local hand = require "src.model.hand"
local card = require "src.model.card"

local match = {}
local mtMatch = { __index = match }

match.config = 
{
	maxCardLevel = 5, 
	hands =
	{
		"first",
		"second",
		"third",
		"fourth",
		"fifth",
		first=1,
		second=2,
		third=3,
		fourth=4,
		fifth=5,

		size = 5
	},

	turn =
	{
		player = "player",
		rival = "rival",
		status =
		{
			beginning = "beginning",
			onGoing = "onGoing",
			ending = "ending"
		}
	}
}

function match.new(matchData)

	local newMatch = {}

	local function initializeHands()

		local hands = {}

		for i=1,match.config.hands.size do
			hands[i] = hand.new({})
		end

		return hands
	end

	newMatch.player =
	{
		hands = matchData.playerHands or initializeHands(),
		cardLevel = matchData.cardLevel or 1
	}

	newMatch.rival =
	{
		hands = matchData.rivalHands or initializeHands(),
		cardLevel = matchData.cardLevel or 1
	}

	newMatch.turn = 
	{
		who = match.config.turn.player,
		status = match.config.turn.status.beginning,
		total = 1
	}

	return setmetatable(newMatch, mtMatch)
end

function match:nextTurn()

	local function updateCardLevel()

		local hands, cardLevel

		if self.turn.who == match.config.turn.player then
			hands = self.player.hands
			cardLevel = self.player.cardLevel
		else
			hands = self.rival.hands
			cardLevel = self.rival.cardLevel
		end

		local isCardLevelToUpdate = true

		for kHand, vHand in pairs(hands) do
			isCardLevelToUpdate = (isCardLevelToUpdate == true) and (#(vHand.cards) == cardLevel)
			--print(#(vHand.cards), cardLevel)
		end

		if isCardLevelToUpdate == true then
			if self.turn.who == match.config.turn.player then
				self.player.cardLevel = self.player.cardLevel + 1
			else
				self.rival.cardLevel = self.rival.cardLevel + 1
			end
		end	
	end

	updateCardLevel()

	if self.turn.who == match.config.turn.player then
		self.turn.who = self.turn.who == match.config.turn.rival
	else
		self.turn.who = match.config.turn.player
	end

	self.turn.status = match.config.turn.status.beginning
	self.turn.total = self.turn.total + 1
end

function match:nextCardLevel(params)

	local result = false

	if params.isPlayerCardLevel then

		local isPlayerCardLevel = params.isPlayerCardLevel

		if isPlayerCardLevel == true and self.player.cardLevel <= match.config.hands.size then

			self.player.cardLevel = self.player.cardLevel + 1
			result = true

		elseif isPlayerCardLevel == false and self.rival.cardLevel <= match.config.hands.size then

			self.rival.cardLevel = self.rival.cardLevel + 1
			result = true
		end
	end
end

function match:getTurnInformation()

	local isPlayerTurn, cardLevel

	if self.turn.who == match.config.turn.player then
		isPlayerTurn, cardLevel = true, self.player.cardLevel
	else
		isPlayerTurn, cardLevel = false, self.rival.cardLevel
	end

	return isPlayerTurn, cardLevel
end

function match:getHand(params)

	local hand

	if params.isPlayer ~= nil and params.handIndex then

		local isPlayer = params.isPlayer
		local handIndex = params.handIndex

		if isPlayer == true then
			hand = self.player.hands[handIndex]
		else
			hand = self.rival.hands[handIndex]
		end
	end

	return hand

end

function match:addCardToHand(params)

	local result = false 

	if params.card and params.handIndex then

		local card = params.card
		local handIndex = params.handIndex

		if self.turn.who == match.config.turn.player then
			result = self.player.hands[handIndex]:addCard(card)
		else
			result = self.rival.hands[handIndex]:addCard(card)
		end
	end

	return result
end

function match:showDown()

	local playerRankings = {}

	print("Showdown")

	for kHand, vHand in ipairs(self.player.hands) do
		playerRankings[kHand] = vHand:checkRanking()
		-- print("Hand enum result = ", playerRankings[kHand].ranking, playerRankings[kHand].value)
		print("Hand Result = ", 
			hand.config.ranking[playerRankings[kHand].ranking].." : "..card.config.value[playerRankings[kHand].value])
	end

end

return match