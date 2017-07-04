local composer = require( "composer" )
local widget = require("widget")

local scene = composer.newScene()
 
-- create()
function scene:create( event )
 
    local sceneGroup = self.view
 
    composer.recycleOnSceneChange = true

    local background = display.newImage("assets/img/menu/gameover-background.png", display.actualContentWidth, display.actualContentHeight)
    sceneGroup:insert(background)

    local difficultyText = display.newText("DIFFICULTY", display.contentCenterX, display.contentCenterY - 120, "assets/fonts/deftone-stylus.ttf", 40)
    difficultyText:setFillColor(0)
    
    sceneGroup:insert(difficultyText)

    local function onNewGameRelease(difficulty)

        local options = { effect = "fade", time = 500, params = { difficulty = difficulty} }
        composer.gotoScene("src.scene.gameplay", options)
    end

    local function onNewEasyGameRelease() onNewGameRelease("easy") end
    local function onNewMediumGameRelease() onNewGameRelease("medium") end
    local function onNewHardGameRelease() onNewGameRelease("hard") end

    local easyButton = widget.newButton{
        label="Easy",
        labelColor = { default={0}, over={128} },
        defaultFile = "assets/img/menu/grey-button.png",
        overFile = "assets/img/menu/grey-button.png",
        width = 134, height= 50,
        font = "assets/fonts/PokerKings-Regular.ttf",
        onRelease = onNewEasyGameRelease
    }

    easyButton.x = display.contentCenterX
    easyButton.y = display.contentCenterY - 40

    sceneGroup:insert(easyButton)

    local mediumButton = widget.newButton{
        label="Medium",
        labelColor = { default={0}, over={128} },
        defaultFile = "assets/img/menu/grey-button.png",
        overFile = "assets/img/menu/grey-button.png",
        width = 134, height= 50,
        font = "assets/fonts/PokerKings-Regular.ttf",
        onRelease = onNewMediumGameRelease
    }

    mediumButton.x = display.contentCenterX 
    mediumButton.y = display.contentCenterY + 20
    mediumButton:setEnabled(false)

    sceneGroup:insert(mediumButton)
 
    local mediumButtonLock = display.newImage("assets/img/menu/lock.png", 2, 2)
    mediumButtonLock:translate(display.contentCenterX+45, display.contentCenterY + 25)
    sceneGroup:insert(mediumButtonLock)

    local hardButton = widget.newButton{
        label="Hard",
        labelColor = { default={0}, over={128} },
        defaultFile = "assets/img/menu/grey-button.png",
        overFile = "assets/img/menu/grey-button.png",
        width = 134, height= 50,
        font = "assets/fonts/PokerKings-Regular.ttf",
        onRelease = onNewHardGameRelease
    }

    hardButton.x = display.contentCenterX
    hardButton.y = display.contentCenterY + 80
    hardButton:setEnabled(false)
    sceneGroup:insert(hardButton)

    local hardButtonLock = display.newImage("assets/img/menu/lock.png", 2, 2)
    hardButtonLock:translate(display.contentCenterX+45, display.contentCenterY + 85)
    sceneGroup:insert(hardButtonLock)
end 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if (phase == "will") then
 
    elseif (phase == "did") then

    end
end
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
 
    elseif ( phase == "did" ) then
 
    end
end

-- destroy()
function scene:destroy( event )
 
    local sceneGroup = self.view
end
 

-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)
--------------------------------------------------------------------------------------
 
return scene