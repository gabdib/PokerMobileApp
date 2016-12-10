-----------------------------------------------------------------------------------------
--
-- gameplay.lua
--
-----------------------------------------------------------------------------------------

local widget = require("widget")
local composer = require("composer")
local scene = composer.newScene()

local deck = require "src.model.deck"
local card = require "src.model.card"
local sound = require "src.utility.sound"


uiDelta = 
{
	deck = {x = 250, y = 0},
	name = {x = 250, y = 150},
	card = 
	{
		initial = {x = 250, y = 30}
	},
	score = {x = 250, y = 100}

}

cardPosition =
{

}

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

		end
	end

	return true
end

function scene:create(event)

	local sceneGroup = self.view

	local function setupUi()

		local background = display.newImageRect("assets/img/game/background.jpg", display.actualContentWidth, display.actualContentHeight)
		background.anchorX = 0
		background.anchorY = 0
		background.x = 0 + display.screenOriginX 
		background.y = 0 + display.screenOriginY

		sceneGroup:insert(background)

		local rivalName = display.newText("RIVAL", display.contentCenterX-uiDelta.name.x, display.contentCenterY-uiDelta.name.y, native.systemFont, 16)
		rivalName:setFillColor(1)
		sceneGroup:insert(rivalName)

		rivalScore = display.newText("0", display.contentCenterX-uiDelta.score.x, display.contentCenterY-uiDelta.score.y, native.systemFont, 32)
		rivalScore:setFillColor(1)
		sceneGroup:insert(rivalScore)

		local playerName = display.newText("PLAYER", display.contentCenterX-uiDelta.name.x, display.contentCenterY+uiDelta.name.y, native.systemFont, 16)
		playerName:setFillColor(1)
		sceneGroup:insert(playerName)

		local playerScore = display.newText("0", display.contentCenterX-uiDelta.score.x, display.contentCenterY+uiDelta.score.y, native.systemFont, 32)
		playerScore:setFillColor(1)
		sceneGroup:insert(playerScore)
	end

	setupUi()

	local currDeck = deck:new({})

	currDeck:shuffle()

	cardDeltaY = 40

	nextCardPos = {x = display.contentCenterX-160, y = display.contentCenterY+cardDeltaY}

	cardNumber = 0

	local function onDeckButtonRelease()

		local card = currDeck:getCard()

		if card then

			sound.play(sound.cardFlip)

			local cardImage = display.newImageRect(card:getImagePath(), card.config.width, card.config.height)
			
			cardImage:addEventListener("touch", onDrag)

			cardImage.x = display.contentCenterX - uiDelta.card.initial.x
			cardImage.y = display.contentCenterY - uiDelta.card.initial.y

			nextCardPos.x = nextCardPos.x + 100

			sceneGroup:insert(cardImage)
		else
			return false

		end

		return true
	end

	deckButton = widget.newButton{
		labelColor = { default={0}, over={128} },
		defaultFile = "assets/img/game/cards/blue.png",
		width = card.config.width, height = card.config.height,
		onRelease = onDeckButtonRelease
	}

	deckButton.x = display.contentCenterX - uiDelta.deck.x
	deckButton.y = display.contentCenterY - uiDelta.deck.y

	sceneGroup:insert(deckButton)
end

function scene:show(event)

	local sceneGroup = self.view

	local function updateUi(updateData)

		if updateData.rivalScore then rivalScore.text = updateData.rivalScore end

		if updateData.playerScore then playerScore.text = updateData.playerScore end 

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