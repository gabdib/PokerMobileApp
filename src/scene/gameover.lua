local composer = require( "composer" )
 local widget = require("widget")

local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 
 
 
 
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
 
    local sceneGroup = self.view
 
    composer.removeScene("gameplay")

    local gameResult = event.params.gameResult

    local resultMessage = ""
    if gameResult and gameResult.winner then
        if gameResult.winner == "player" then
            resultMessage = "You Win!"
        elseif gameResult.winner == "rival" then
            resultMessage = "You Lost!"
        end
    end
    
    local background = display.newImage("assets/img/menu/background.jpg", display.actualContentWidth, display.actualContentHeight)
    
    sceneGroup:insert(background)

    local resultText = display.newText(resultMessage, display.contentCenterX, display.contentCenterY, native.systemFont, 32)
    resultText:setFillColor(0)
    
    sceneGroup:insert(resultText)

    local function onReplayButtonRelease()
        
        composer.gotoScene("src.scene.gameplay", "fade", 500)
        
        return true
    end

    local replayButton = widget.newButton{
        label="Replay",
        labelColor = { default={0}, over={128} },
        defaultFile = "assets/img/menu/button.png",
        overFile = "assets/img/menu/button-over.png",
        width =154, height=40,
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
        labelColor = { default={0}, over={128} },
        defaultFile = "assets/img/menu/button.png",
        overFile = "assets/img/menu/button-over.png",
        width =154, height=40,
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
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
 
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
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------
 
return scene