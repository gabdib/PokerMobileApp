-----------------------------------------------------------------------------------------
--
-- sound.lua
--
-----------------------------------------------------------------------------------------

local sound = {}

sound = {
   	cardFlip = audio.loadSound('assets/sounds/cardFlip.wav'),
    shuffle = audio.loadSound('assets/sounds/shuffle.wav')
}

function sound.play(sound)
	if sound then
		audio.play(sound)
	end
end

return sound