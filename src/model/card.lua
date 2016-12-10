-----------------------------------------------------------------------------------------
--
-- card.lua
--
-----------------------------------------------------------------------------------------

local card = {}
local mtCard = { __index = card }

card.config = 
{
    back = 'assets/img/game/cards/blue.png',

    height = 80,
    width = 60,
	filePath = "assets/img/game/cards/",
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

    local newCard = {}

	newCard.suit = cardData.suit
	newCard.value = cardData.value
    newCard.imagePath = card.config.filePath..newCard.suit..newCard.value..card.config.fileExtension

    return setmetatable(newCard, mtCard)

end

function card:getImagePath()

	return self.imagePath
end

return card