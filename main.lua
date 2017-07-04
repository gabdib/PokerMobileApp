-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

display.setStatusBar(display.HiddenStatusBar)

local platformName = system.getInfo("platformName")
if platformName == "Android" then
	native.setProperty('androidSystemUiVisibility', 'immersiveSticky')
end

local composer = require ("composer")
composer.gotoScene("src.scene.menu")

-- local tester = require "src.utility.tester"
-- tester.test()