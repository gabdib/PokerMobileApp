-----------------------------------------------------------------------------------------
--
-- ranking.lua
--
-----------------------------------------------------------------------------------------

local card = require "src.model.card"

local ranking = {}
local mtRanking = { __index = ranking}

ranking.config = 
{

}

function ranking.initialize(cards)

	local newRanking = {}

	newRanking.cards = cards

	return setmetatable(newRanking, mtRanking)
end

function ranking:checkRanking()

	local ranking

	checkKind()

	return ranking 

end

function ranking:checkKind()

	local resultRanking = ""

	local weights = {}

	for i=1,#self.cards do 
		weights[i] = 0
	end

	for i=1,#self.cards do 
		weights[i] = weights[i] + 1
	end

	for k,v in ipairs(weights) do
		print(k,v)
	end

	return result

end

return ranking