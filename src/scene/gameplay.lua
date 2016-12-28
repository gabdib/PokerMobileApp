-----------------------------------------------------------------------------------------
--
-- gameplay.lua
--
-----------------------------------------------------------------------------------------

local deck = require "src.model.deck"
local card = require "src.model.card"
local sound = require "src.utility.sound"
local layout = require "src.utility.layout"
local match = require "src.model.match"

local widget = require("widget")
local composer = require("composer")
local scene = composer.newScene()


function scene:create(event)

	local sceneGroup = self.view

	currDeck = deck.new({})
	currDeck:shuffle()
	currMatch = match.new({})

	local function onDrag(event)

		local t = event.target

		if event.phase == "began" then
			t.xScale, t.yScale = 1.1, 1.1
			t:toFront()
			display.getCurrentStage():setFocus(t)
			t.isFocus = true
			xOrigin,yOrigin = t.x,t.y
			t.x0 = event.x - t.x
			t.y0 = event.y - t.y

		elseif t.isFocus then

			if "moved" == event.phase then

				t.x = event.x - t.x0
				t.y = event.y - t.y0

			elseif "ended" == event.phase or "cancelled" == event.phase then

				display.getCurrentStage():setFocus(nil)
				t.isFocus = false
				t.xScale, t.yScale = 1.0, 1.0

				local function computePosition()

					local index, position

					if t.x and t.y then

						local isPlayerTurn, cardLevel = currMatch:getTurnInformation()
						local cardPositionList = layout.getCardPositionList({isPlayer = isPlayerTurn, level = cardLevel})

						if cardPositionList then

							for i,pos in pairs(cardPositionList) do

								if t.x >= pos.x-card.config.width/2 and t.x <= pos.x+card.config.width/2
									and t.y >= pos.y-card.config.height/2 and t.y <= pos.y+card.config.height/2 then

									index, position = i,pos

									break
								end
							end
						end
					end

					return index,position
				end

				local i,pos = computePosition()

				local isPlayerTurn, cardLevel = currMatch:getTurnInformation()

				local hand

				if i and pos then
					hand = currMatch:getHand({isPlayer = isPlayerTurn, handIndex = i}) 
				end

				if hand and #(hand.cards) == (cardLevel-1) then
					t.x, t.y = pos.x, pos.y
					t:removeEventListener("touch", onDrag)
					local result = currMatch:addCardToHand({card = t.card, handIndex = i})
					currMatch:nextTurn()
				else
					t.x, t.y = layout.initialCardPosition(currMatch.turn.who)
				end
			end
		end

		return true
	end

	local function setupUi()

		background = display.newImageRect("assets/img/game/background.jpg", display.actualContentWidth, display.actualContentHeight)
		background.anchorX = 0
		background.anchorY = 0
		background.x = 0 + display.screenOriginX 
		background.y = 0 + display.screenOriginY

		sceneGroup:insert(background)

		rivalName = display.newText("RIVAL", layout.position.rival.name.x, layout.position.rival.name.y, native.systemFont, 16)
		rivalName:setFillColor(1)
		sceneGroup:insert(rivalName)

		rivalScore = display.newText("0", layout.position.rival.score.x, layout.position.rival.score.y, native.systemFont, 32)
		rivalScore:setFillColor(1)
		sceneGroup:insert(rivalScore)

		playerName = display.newText("PLAYER", layout.position.player.name.x, layout.position.player.name.y, native.systemFont, 16)
		playerName:setFillColor(1)
		sceneGroup:insert(playerName)

		playerScore = display.newText("0", layout.position.player.score.x, layout.position.player.score.y, native.systemFont, 32)
		playerScore:setFillColor(1)
		sceneGroup:insert(playerScore)

		local function displayCardImage(card, position, isEventListenerToAdd)

			local result = false

			if card and card.imagePath and position.x and position.y then

				local cardImage = display.newImageRect(card.imagePath, card.config.width, card.config.height)

				if isEventListenerToAdd == true then
					cardImage.card = card
					cardImage:addEventListener("touch", onDrag)
				end

				cardImage.x, cardImage.y = position.x,position.y
				sceneGroup:insert(cardImage)

				result = true
			end

			return result
		end

		deckButton = widget.newButton{
		labelColor = { default={0}, over={128} },
		defaultFile = "assets/img/game/cards/blue.png",
		width = card.config.width, height = card.config.height,
		onRelease = 
			function ()
				
				local result = false

				if currMatch.turn.status == match.config.turn.status.beginning then

					currMatch.turn.status = match.config.turn.status.ongGoing

					local card = currDeck:getCard()

					sound.play(sound.cardFlip)

					local x,y = layout.initialCardPosition(currMatch.turn.who)
					local position = {x=x, y=y}
					local result = displayCardImage(card, position, true)
				end

				return result
			end
		}

		deckButton.x, deckButton.y = layout.position.deck.x, layout.position.deck.y

		sceneGroup:insert(deckButton)

		local function initializeFirstLevel(who)

			local firstLevelPositions = layout.getPositionsByLevel({who=who, level = 1})

			for handIndex=1, #firstLevelPositions do

				local card = currDeck:getCard()

				if card then
					displayCardImage(card, firstLevelPositions[handIndex], false)
					currMatch:addCardToHand({card=card, handIndex=handIndex})
					currMatch:nextTurn()
				end
			end
		end

		initializeFirstLevel(match.config.turn.player)
		initializeFirstLevel(match.config.turn.rival)
	end

	setupUi()
end

function scene:show(event)

	local sceneGroup = self.view

	local function updateUi(params)

		if params.rivalScore then rivalScore.text = updateData.rivalScore end
		if params.playerScore then playerScore.text = updateData.playerScore end 
	end

	local phase = event.phase
	
	if phase == "will" then

	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
	end	
end

function scene:hide(event)

	local sceneGroup = self.view

	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end
end

function scene:destroy( event )
	local sceneGroup = self.view
	
	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
end
---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

-----------------------------------------------------------------------------------------

return scene