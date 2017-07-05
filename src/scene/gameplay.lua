-----------------------------------------------------------------------------------------
--
-- gameplay.lua
--
-----------------------------------------------------------------------------------------

local deck = require "src.model.deck"
local card = require "src.model.card"
local sound = require "src.utility.sound"
local match = require "src.model.match"

local layout = require "src.utility.layout"

local pokerbot = require "src.bot.pokerbot"
local easyPokerbot = require "src.bot.easypokerbot"
local mediumPokerbot = require "src.bot.mediumpokerbot"
local hardPokerbot = require "src.bot.hardpokerbot"

local widget = require("widget")
local composer = require("composer")

local scene = composer.newScene()

function scene:create(event)

	local sceneGroup = self.view

	composer.recycleOnSceneChange = true

	currDeck = deck.new({})
	currDeck:shuffle()
	currMatch = match.new({})

	layout.initialize()

	local difficulty = event.params.difficulty

	if difficulty then

		if difficulty == "easy" then
			pokerbot = easyPokerbot.new({})
		elseif difficulty == "medium" then
			pokerbot = mediumPokerbot.new({})
		elseif difficulty == "hard" then
			pokerbot = hardPokerbot.new({})
		else
			pokerbot = pokerbot.new({})
		end
	end

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
								-- if card is released on a valid position
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

				-- if the cards is added on a valid hand => remove event listener and start new turn
				if hand and #(hand.cards) == (cardLevel-1) then
					t.x, t.y = pos.x, pos.y
					t:removeEventListener("touch", onDrag)
					local result = currMatch:addCardToHand({card = t.card, handIndex = i})
					currMatch:nextTurn()
					
					-- if previous turn was a player turn => play bot turn
					if isPlayerTurn then self:playTurn() end

					-- if the match is ended => showdown
					if currMatch.player.cardLevel == currMatch.rival.cardLevel and currMatch.player.cardLevel == (match.config.maxCardLevel+1) then
						
						local function showdown()
							
							local gameResult = {}

							local playerRankings, rivalRankings = currMatch:showDown()

							local playerRankPositions = layout.getPositionsByLevel({who=match.config.turn.player, level = 5})
							local rivalRankPositions = layout.getPositionsByLevel({who=match.config.turn.rival, level = 5})

							local winPosition, losePosition
							local playerWinningCounter, rivalWinningCounter = 0,0

							local checkHand
							for iHand=1, match.config.hands.size do
								
								local rivalHand = currMatch:getHand({isPlayer = false, handIndex = iHand})
								local rivalCard = rivalHand.cards[hand.config.size]

								local cardImage = display.newImageRect(rivalCard.imagePath, rivalCard.config.width, rivalCard.config.height)

								cardImage.x, cardImage.y = rivalRankPositions[iHand].x,rivalRankPositions[iHand].y
								sceneGroup:insert(cardImage)

								if playerRankings[iHand].ranking > rivalRankings[iHand].ranking then
									winPosition, losePosition = playerRankPositions[iHand], rivalRankPositions[iHand]
									winPosition.y,losePosition.y = winPosition.y+30,losePosition.y-30
									playerWinningCounter = playerWinningCounter + 1
								elseif playerRankings[iHand].ranking < rivalRankings[iHand].ranking then
									winPosition,losePosition = rivalRankPositions[iHand],playerRankPositions[iHand]
									winPosition.y,losePosition.y = winPosition.y-30,losePosition.y+30
									rivalWinningCounter = rivalWinningCounter + 1
								else
									if playerRankings[iHand].value > rivalRankings[iHand].value then
										winPosition, losePosition = playerRankPositions[iHand], rivalRankPositions[iHand]
										winPosition.y,losePosition.y = winPosition.y+30,losePosition.y-30
										playerWinningCounter = playerWinningCounter + 1
									else
										winPosition, losePosition = rivalRankPositions[iHand], playerRankPositions[iHand]
										winPosition.y,losePosition.y = winPosition.y-30,losePosition.y+30
										rivalWinningCounter = rivalWinningCounter + 1
									end
								end

								local function showHandResult() 
									local winIcon = display.newImageRect("assets/img/game/winner.png", 28, 28)
									winIcon.x, winIcon.y = winPosition.x, winPosition.y
									sceneGroup:insert(winIcon)
									transition.fadeIn( winIcon, {time=2000 })

									local loseIcon = display.newImageRect("assets/img/game/loser.png", 28, 28)
									loseIcon.x, loseIcon.y = losePosition.x, losePosition.y
									sceneGroup:insert(loseIcon)
									transition.fadeIn(loseIcon, { time=2000 })
								end

								--timer.performWithDelay(1000, showHandResult)
								showHandResult()
							end

							if playerWinningCounter > rivalWinningCounter then
								gameResult.winner = "player"
							else
								gameResult.winner = "rival"
							end

							return gameResult
						end

						local gameResult = showdown()

						local function gotoGameoverScene()

							local options = { effect = "crossFade", time = 2500, params = { gameResult = gameResult, difficulty = difficulty} }

							composer.showOverlay("src.scene.gameover", options)
						end

						timer.performWithDelay(3000, gotoGameoverScene)
					end
				else
					t.x, t.y = layout.initialCardPosition(currMatch.turn.who)
				end
			end
		end

		return true
	end

	function setupUi()

		background = display.newImageRect("assets/img/game/background.jpg", display.actualContentWidth, display.actualContentHeight)
		background.anchorX = 0
		background.anchorY = 0
		background.x = 0 + display.screenOriginX 
		background.y = 0 + display.screenOriginY

		sceneGroup:insert(background)

		rivalName = display.newText("RIVAL", layout.position.rival.name.x, layout.position.rival.name.y, "assets/fonts/PokerKings-Regular.ttf", 16)
		rivalName:setFillColor(1)
		sceneGroup:insert(rivalName)

		rivalIcon = display.newImageRect("assets/img/game/rival.png", 48, 48)
		rivalIcon.x, rivalIcon.y = layout.position.rival.icon.x, layout.position.rival.icon.y
		rivalIcon:setFillColor(1)
		sceneGroup:insert(rivalIcon)

		playerName = display.newText("PLAYER", layout.position.player.name.x, layout.position.player.name.y, "assets/fonts/PokerKings-Regular.ttf", 16)
		playerName:setFillColor(1)
		sceneGroup:insert(playerName)

		playerIcon = display.newImageRect("assets/img/game/player.png", 48, 48)
		playerIcon.x, playerIcon.y = layout.position.player.icon.x, layout.position.player.icon.y
		playerIcon:setFillColor(1)
		sceneGroup:insert(playerIcon)

		function displayCardImage(card, position, isEventListenerToAdd)

			local result = false

			if card and card.imagePath and position.x and position.y then

				local cardImage

				local isPlayerTurn, cardLevel = currMatch:getTurnInformation()

				if isPlayerTurn == true or (isPlayerTurn == false and cardLevel < match.config.maxCardLevel) then
					cardImage = display.newImageRect(card.imagePath, card.config.width, card.config.height)
				elseif isPlayerTurn == false and cardLevel == match.config.maxCardLevel then
					cardImage = display.newImageRect(card.config.back, card.config.width, card.config.height)
				end

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
			defaultFile = card.config.back,
			width = card.config.width, height = card.config.height,
			onRelease = function ()
				
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
					--currMatch:nextTurn()
				end
			end
		end

		initializeFirstLevel(match.config.turn.player)
		currMatch:nextTurn()
		initializeFirstLevel(match.config.turn.rival)
		currMatch:nextTurn()
	end

	setupUi()
end

function scene:show(event)

	local sceneGroup = self.view

	local function updateUi(params)

		if params.rivalScore then rivalScore.text = updateData.rivalScore end
		if params.playerScore then playerScore.text = updateData.playerScore end 
	end
end

function scene:hide(event)
	local sceneGroup = self.view
end

function scene:destroy(event)
	local sceneGroup = self.view
end
---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

-----------------------------------------------------------------------------------------

function scene:playTurn()

	local sceneGroup = self.view

				
	local result = false

	if currMatch.turn.status == match.config.turn.status.beginning then

		currMatch.turn.status = match.config.turn.status.ongGoing

		local card = currDeck:getCard()

		local isPlayerTurn, cardLevel = currMatch:getTurnInformation()
		
		local handIndex = pokerbot:playTurn(currMatch, card, cardLevel)

		if handIndex and handIndex > 0 then
			local cardPositionList = layout.getCardPositionList({isPlayer = isPlayerTurn, level = cardLevel})
			local position = {x = cardPositionList[handIndex].x, y = cardPositionList[handIndex].y}
				
			sound.play(sound.cardFlip)

			local result = displayCardImage(card, position , false)

			currMatch:addCardToHand({card = card, handIndex = handIndex})
				
			currMatch:nextTurn()
		end
	end
end

return scene