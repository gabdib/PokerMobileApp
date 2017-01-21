-----------------------------------------------------------------------------------------
--
-- tester.lua
--
-----------------------------------------------------------------------------------------

local match = require "src.model.match"
local hand = require "src.model.hand"
local card = require "src.model.card"
local deck = require "src.model.deck"

local tester = {}

function tester.printHands(hands)
	for kHand,vHand in ipairs(hands) do
		print("\tHand ", kHand)

		for iCard,vCard in ipairs(vHand.cards) do
			print("\t\t", vCard:toString())
		end
	end
end

function tester.rankingTest()

	local currDeck = deck.new({})
	currDeck:shuffle()


	local currMatch = match.new({})

	local currentCard

	for player=1,2 do
		for iHand=1, match.config.hands.size do
			for iCard=1,hand.config.size do

				currentCard = currDeck:getCard()

				currMatch:addCardToHand({handIndex = iHand, card = currentCard})
				currMatch:nextTurn()
			end
		end
	end

	print("PLAYER HANDS:")
	tester.printHands(currMatch.player.hands)

	print("RIVAL HANDS:")
	tester.printHands(currMatch.rival.hands)

	currMatch:showDown()

end

return tester