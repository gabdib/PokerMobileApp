-----------------------------------------------------------------------------------------
--
-- card.lua
--
-----------------------------------------------------------------------------------------

local card = {}
local mtCard = { __index = card }

card.config = 
{
    back = 'img/game/cards/blue.png',

    height = 80,
    width = 60,
	filePath = "img/game/cards/",
    fileExtension = ".png",

    suit = {
        "spade",
        "club",
        "heart",
        "diamond",
        spade = 1,
        club = 2,
        heart = 3,
        diamond = 4
    }
}

function card.new(cardData)

	local suit = cardData.suit
	local value = cardData.value
    local imagePath = card.config.filePath..suit..value..card.config.fileExtension

    local newCard =
    {
        suit = suit,
        value = value,
        imagePath = imagePath
    }

    return setmetatable(newCard, mtCard)

end

function card:getImagePath()

	return self.imagePath
end

return card