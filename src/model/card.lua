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

    height = 50,
    width = 37.5,
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

	newCard.suit = cardData.suit or 0
	newCard.value = cardData.value or 0

    if newCard.suit == 0 or newCard.value == 0 then
        newCard.imagePath = card.config.back
    else
        newCard.imagePath = card.config.filePath..newCard.suit..newCard.value..card.config.fileExtension
    end

    return setmetatable(newCard, mtCard)

end

function card:getImagePath()

	return self.imagePath
end

return card