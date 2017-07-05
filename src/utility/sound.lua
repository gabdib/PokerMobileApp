-----------------------------------------------------------------------------------------
--
-- sound.lua
--
-----------------------------------------------------------------------------------------

local sound = {}

sound = {
   	cardFlip = audio.loadSound('assets/sounds/cardFlip.wav'),
    shuffle = audio.loadSound('assets/sounds/shuffle.wav'),
    winner = audio.loadSound('assets/sounds/winner.mp3'),
    loser = audio.loadSound('assets/sounds/loser.mp3')
}

function sound.play(sound)
	if sound then
		audio.play(sound)
	end
end

return sound