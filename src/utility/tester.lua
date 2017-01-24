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

function tester.compareResults(actualResult, expectedResult, description)
	
	local areEquals

	if actualResult.value == expectedResult.value and actualResult.ranking == expectedResult.ranking then	
		print(description, "=> PASSED")
		areEquals = true
	else
		print(description, "=> ERROR")
		print("\tActual Result = ", hand.config.ranking[actualResult.ranking].." : "..card.config.value[actualResult.value])
		print("\tExpected Result = ", hand.config.ranking[expectedResult.ranking].." : "..card.config.value[expectedResult.value])
		areEquals = false
	end

	return areEquals
end

function tester.randomRankingTest()

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

function tester.testStraight()

	local straightFlushHand = hand.new({
		index = 1,
		cards =
		{
			card.new({suit = 1, value = 10}),
			card.new({suit = 1, value = 11}),
			card.new({suit = 1, value = 12}),
			card.new({suit = 1, value = 13}),
			card.new({suit = 1, value = 1})
		}
	})

	local resultsToCompare =
	{
		{
			description = "Straight flush : Five",
			actual = hand.new({index = 1, cards = {card.new({suit = 1, value = 1}), card.new({suit = 1, value = 2}), card.new({suit = 1, value = 3}), card.new({suit = 1, value = 4}), card.new({suit = 1, value = 5})}}):checkRanking(),
			expected = {value = 5, ranking = hand.config.ranking.straightFlush}
		},
		{
			description = "Straight : Six",
			actual = hand.new({index = 2, cards = {card.new({suit = 3, value = 2}), card.new({suit = 3, value = 3}), card.new({suit = 4, value = 4}), card.new({suit = 2, value = 5}), card.new({suit = 1, value = 6})}}):checkRanking(),
			expected = {value = 6, ranking = hand.config.ranking.straight}
		},
		{
			description = "Royal Flush",
			actual = hand.new({index = 3, cards = {card.new({suit = 1, value = 10}), card.new({suit = 1, value = 11}), card.new({suit = 1, value = 12}), card.new({suit = 1, value = 13}), card.new({suit = 1, value = 1})}}):checkRanking(),
			expected = {value = 1, ranking = hand.config.ranking.royalFlush}
		}
	}

	for i,v in ipairs(resultsToCompare) do
		tester.compareResults(v.actual, v.expected, v.description)
	end
end

function tester.testMatch()

	local currMatch = match.new({})

	currMatch.player.hands =
	{
		-- expected result => Straight flush : Five
		hand.new({
			index = 1,
			cards =
			{
				card.new({suit = 1, value = 1}),
				card.new({suit = 1, value = 2}),
				card.new({suit = 1, value = 3}),
				card.new({suit = 1, value = 4}),
				card.new({suit = 1, value = 5})
			}
		}),
		-- expected result => Flush : Ten
		hand.new({
			index = 2,
			cards =
			{
				card.new({suit = 2, value = 3}),
				card.new({suit = 2, value = 7}),
				card.new({suit = 2, value = 10}),
				card.new({suit = 2, value = 4}),
				card.new({suit = 2, value = 6})
			}
		}),
		-- expected result => Straight : Six
		hand.new({
			index = 3,
			cards =
			{
				card.new({suit = 3, value = 2}),
				card.new({suit = 3, value = 3}),
				card.new({suit = 4, value = 4}),
				card.new({suit = 2, value = 5}),
				card.new({suit = 1, value = 6})
			}
		}),
		-- expected result => Straight flush : Jack
		hand.new({
			index = 4,
			cards =
			{
				card.new({suit = 4, value = 7}),
				card.new({suit = 4, value = 8}),
				card.new({suit = 4, value = 9}),
				card.new({suit = 4, value = 10}),
				card.new({suit = 4, value = 11})
			}
		}),
		-- expected result => Straight : Jack
		hand.new({
			index = 5,
			cards =
			{
				card.new({suit = 3, value = 7}),
				card.new({suit = 2, value = 8}),
				card.new({suit = 1, value = 9}),
				card.new({suit = 2, value = 10}),
				card.new({suit = 1, value = 11})
			}
		}),
	}

	currMatch.player.cardLevel = 5

	currMatch:showDown()

end

function tester.test()

	tester.testStraight()
	
end


return tester