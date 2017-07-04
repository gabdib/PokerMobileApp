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
	name = {x = 200, y = 140},
	card = 
	{
		initial = {x = 200, y = 30}
	},
	icon = {x = 200, y = 90}
}

function layout.generateCardPositionList(isPlayer)

	local cardPositions = {}

	local startingX = display.contentCenterX - 200
	local startingY = display.contentCenterY 
			
	local deltaX = 70
	local deltaY = 20

	if isPlayer == true then 
		cardPositions.initial =
		{
			x = display.contentCenterX-layout.contentCenterDelta.card.initial.x,
			y = display.contentCenterY+layout.contentCenterDelta.card.initial.y
		}

		startingY = startingY + deltaY/2
	else 
		deltaY = deltaY * (-1)
		cardPositions.initial =
		{
			x = display.contentCenterX-layout.contentCenterDelta.card.initial.x,
			y = display.contentCenterY-layout.contentCenterDelta.card.initial.y
		}
		startingY = startingY + deltaY/2
	end

	for iHand = 1, 5 do
		cardPositions[iHand] = {}
		for iCard = 1, 5 do
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

	--printCardPositions()

	return cardPositions
end

layout.position =
{
	player = 
	{
		name = {x = display.contentCenterX-layout.contentCenterDelta.name.x, y = display.contentCenterY+layout.contentCenterDelta.name.y},
		icon = {x =display.contentCenterX-layout.contentCenterDelta.icon.x , y = display.contentCenterY+layout.contentCenterDelta.icon.y},
		card = layout.generateCardPositionList(true)
	},
	
	rival =
	{
		name = {x = display.contentCenterX-layout.contentCenterDelta.name.x, y = display.contentCenterY-layout.contentCenterDelta.name.y},
		icon = {x = display.contentCenterX-layout.contentCenterDelta.icon.x, y = display.contentCenterY-layout.contentCenterDelta.icon.y},
		card = layout.generateCardPositionList(false)
	},

	deck = {x = display.contentCenterX-layout.contentCenterDelta.deck.x, y = display.contentCenterY-layout.contentCenterDelta.deck.y}
}


function layout.initialCardPosition(who)
	
	local x,y

	if who and who == match.config.turn.player then
		x,y = layout.position.player.card.initial.x, layout.position.player.card.initial.y
	else
		x, y = layout.position.rival.card.initial.x, layout.position.rival.card.initial.y
	end

	return x,y
end

function layout.getPositionsByLevel(params)

	local positions

	if params.level then

		local level = params.level
			
		if params.who and params.who == match.config.turn.player then
			positions = layout.position.player.card[level]
		else
			positions = layout.position.rival.card[level]
		end
	end

	return positions
end

 
function layout.getCardPositionList(params)
		
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