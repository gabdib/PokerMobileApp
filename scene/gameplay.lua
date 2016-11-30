-----------------------------------------------------------------------------------------
--
-- gameplay.lua
--
-----------------------------------------------------------------------------------------

local widget = require("widget")
local composer = require("composer")
local scene = composer.newScene()


local deck = require "model.deck"

function scene:create(event)

	local sceneGroup = self.view

	local currDeck = deck:new({})

	local background = display.newImageRect("img/game/background.jpg", display.actualContentWidth, display.actualContentHeight)
	background.anchorX = 0
	background.anchorY = 0
	background.x = 0 + display.screenOriginX 
	background.y = 0 + display.screenOriginY

	sceneGroup:insert(background)

	local title = display.newText("Game", display.contentCenterX, 20, native.systemFont, 32)
	title:setFillColor(1)

	sceneGroup:insert(title)

	local function onShowCardButtonRelease()

		local card = currDeck:getCard()

		local cardImage = display.newImageRect(card:getImagePath(), card.config.width, card.config.height)
		cardImage.x = display.contentCenterX
		cardImage.y = display.contentCenterY		

		sceneGroup:insert(cardImage)

		return true
	end

	local showCardButton = widget.newButton{
		label="Show Card",
		labelColor = { default={0}, over={128} },
		defaultFile = "img/menu/button.png",
		overFile = "img/menu/button-over.png",
		width =154, height=40,
		onRelease = onShowCardButtonRelease
	}

	showCardButton.x = display.contentCenterX
	showCardButton.y = 290

	sceneGroup:insert(showCardButton)
end

function scene:show(event)
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
	end	
end

function scene:hide( event )
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