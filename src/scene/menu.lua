-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------

local widget = require ("widget")
local composer = require("composer")

local scene = composer.newScene()

function scene:create(event)
	local sceneGroup = self.view
	
	local background = display.newImage("assets/img/menu/background.jpg", display.actualContentWidth, display.actualContentHeight)
	background.x = display.contentCenterX
	background.y = display.contentCenterY
	sceneGroup:insert(background)

	local title = display.newText("Five-O-lous", display.contentCenterX, display.contentCenterY - 100, "assets/fonts/PokerKings-Regular.ttf", 70)
	sceneGroup:insert(title)
	
	local subtitle = display.newText("poker", display.contentCenterX, display.contentCenterY - 75, "assets/fonts/deftone-stylus.ttf", 30)
	sceneGroup:insert(subtitle)

	local function onPlayButtonRelease()
		
		composer.gotoScene("src.scene.difficulty", "fade", 500)
		
		return true
	end

	local playButton = widget.newButton{
		label="PLAY",
		labelColor = { default={0}, over={128} },
		defaultFile = "assets/img/menu/button.png",
		overFile = "assets/img/menu/button.png",
		width = 154, height= 150,
		font = "assets/fonts/PokerKings-Regular.ttf",
		fontSize = 32,
		onRelease = onPlayButtonRelease
	}

	playButton.x = display.contentCenterX
	playButton.y = display.contentCenterY + 80

	sceneGroup:insert(playButton)
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
	
	if playButton then
		playButton:removeSelf()
		playButton = nil
	end
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

-----------------------------------------------------------------------------------------

return scene