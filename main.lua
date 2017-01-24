-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

display.setStatusBar(display.DefaultStatusBar)

if system.getInfo("platformName") == "Android" then

   local androidVersion = string.sub(system.getInfo("platformVersion"), 1, 3)

   if androidVersion and tonumber(androidVersion) >= 4.4 then

     native.setProperty("androidSystemUiVisibility", "immersiveSticky")

   elseif androidVersion then
     native.setProperty( "androidSystemUiVisibility", "lowProfile")
   end
end

-- local composer = require ("composer")
-- composer.gotoScene("src.scene.menu")

local tester = require "src.utility.tester"

tester.test()