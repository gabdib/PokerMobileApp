-----------------------------------------------------------------------------------------
--
-- layout.lua
--
-----------------------------------------------------------------------------------------

local match = require "src.model.match"

layout = {}

layout.contentCenterDelta = 
{
	deck = {x = 200, y = 0},
	name = {x = 200, y = 100},
	card = 
	{
		initial = {x = 200, y = 30}
	},
	score = {x = 200, y = 70}
}

function layout.generateCardPositionList(isPlayer)

	local cardPositions = {}

	local startingX = display.contentCenterX - 200
	local startingY = display.contentCenterY 
			
	local deltaX = 70
	local deltaY = 20

	if isPlayer == true then 
		cardPositions.initial = {x = display.contentCenterX-layout.contentCenterDelta.card.initial.x, y = display.contentCenterY+layout.contentCenterDelta.card.initial.y}
		startingY = startingY + deltaY/2
	else 
		deltaY = deltaY * (-1)
		cardPositions.initial = {x = display.contentCenterX-layout.contentCenterDelta.card.initial.x, y = display.contentCenterY-layout.contentCenterDelta.card.initial.y}
		startingY = startingY + deltaY/2
	end

	for iHand = 1, match.config.hands.size do
		cardPositions[iHand] = {}
		for iCard = 1, require("src.model.hand").config.size do
			cardPositions[iHand][iCard] = {x = startingX + (deltaX*iCard), y = startingY + (deltaY*iHand)}
		end
	end

	local function printCardPositions()
		for kHand, vHand in pairs(cardPositions) do
	   		if kHand ~= "initial" then
	   			print(kHand.." = ")
		   		for kCard, vCard in pairs(cardPositions[kHand]) do
		   			print("\t"..kCard.." = "..vCard.x..", "..vCard.y)
		   		end
		   	end
		end
	end



	return cardPositions
end

layout.position =
{
	player = 
	{
		name = {x = display.contentCenterX-layout.contentCenterDelta.name.x, y = display.contentCenterY+layout.contentCenterDelta.name.y},
		score = {x =display.contentCenterX-layout.contentCenterDelta.score.x , y = display.contentCenterY+layout.contentCenterDelta.score.y},
		card = layout.generateCardPositionList(true)
	},
	
	rival =
	{
		name = {x = display.contentCenterX-layout.contentCenterDelta.name.x, y = display.contentCenterY-layout.contentCenterDelta.name.y},
		score = {x = display.contentCenterX-layout.contentCenterDelta.score.x, y = display.contentCenterY-layout.contentCenterDelta.score.y},
		card = layout.generateCardPositionList(false)
	},

	deck = {x = display.contentCenterX-layout.contentCenterDelta.deck.x, y = display.contentCenterY-layout.contentCenterDelta.deck.y}
}

layout.initialCardPosition =
	function (who)

		local x,y

		if who and who == match.config.turn.player then
			x,y = layout.position.player.card.initial.x, layout.position.player.card.initial.y
		else
			x, y = layout.position.rival.card.initial.x, layout.position.rival.card.initial.y
		end

		return x,y
	end

layout.getCardPositionList = 
	function (params)
		
		local positionList

		if params.level and params.isPlayer ~= nil then

			local isPlayer = params.isPlayer
			local level = params.level

			if level >= 1 and level <= 5 then

				if isPlayer == true then
					positionList = layout.position.player.card[level]
				else
					positionList = layout.position.rival.card[level]
				end
			end
		end
	
		return positionList
	end

return layout