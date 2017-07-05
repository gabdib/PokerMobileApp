local composer = require( "composer" )
local widget = require("widget")

local sound = require "src.utility.sound"

local scene = composer.newScene()
 
-- create()
function scene:create( event )
 
    local sceneGroup = self.view
 
    composer.removeScene("gameplay")

    local gameResult = event.params.gameResult
    local difficulty = event.params.difficulty

    local resultMessage = ""
    local resultIconPath = ""
    if gameResult and gameResult.winner then
        if gameResult.winner == "player" then
            resultMessage = "You Win"
            resultIconPath = "assets/img/game/winner.png"
            sound.play(sound.winner)
        elseif gameResult.winner == "rival" then
            resultMessage = "You Lose"
            resultIconPath = "assets/img/game/loser.png"
            sound.play(sound.loser)
        end
    end
    
    local background = display.newRect(display.contentCenterX, display.contentCenterY, display.actualContentWidth, display.actualContentHeight)
    background:setFillColor(0,0,0, 0.4)
    sceneGroup:insert(background)

    local resultText = display.newText(resultMessage, display.contentCenterX, display.contentCenterY - 100, "assets/fonts/PokerKings-Regular.ttf", 48)
    resultText:setFillColor(255,255,255)
    sceneGroup:insert(resultText)

    local resultIcon = display.newImage(resultIconPath, 96, 96)
    resultIcon.x, resultIcon.y = display.contentCenterX, display.contentCenterY
    sceneGroup:insert(resultIcon)

    local function onReplayButtonRelease()
               
        composer.gotoScene("src.scene.difficulty", "fade", 500)

        return true
    end

    local replayButton = widget.newButton{
        label="Rematch",
        labelColor = { default={255,255,255}, over={52,152,219} },
        labelYOffset = 50,
        defaultFile = "assets/img/menu/rematch.png",
        overFile = "assets/img/menu/rematch-hover.png",
        width = 50, height = 50,
        font = "assets/fonts/PokerKings-Regular.ttf",
        onRelease = onReplayButtonRelease
    }

    replayButton.x = display.contentCenterX + 100
    replayButton.y = display.contentCenterY + 100

    sceneGroup:insert(replayButton)

    local function onQuitButtonRelease()
        
        composer.gotoScene("src.scene.menu", "fade", 500)
        
        return true
    end

    local quitButton = widget.newButton{
        label="Quit",
        labelColor = { default={255,255,255}, over={52,152,219} },
        labelYOffset = 50,
        defaultFile = "assets/img/menu/quit.png",
        overFile = "assets/img/menu/quit-hover.png",
        width = 50, height = 50,
        font = "assets/fonts/PokerKings-Regular.ttf",
        onRelease = onQuitButtonRelease
    }

    quitButton.x = display.contentCenterX - 100
    quitButton.y = display.contentCenterY + 100

    sceneGroup:insert(quitButton)
 
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
        -- Code here runs when the scene is on screen (but is about to go off screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
 
    end
end

-- destroy()
function scene:destroy( event )
 
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
 
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