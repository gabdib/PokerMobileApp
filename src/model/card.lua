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
        "Spades",
        "Clubs",
        "Hearts",
        "Diamonds",
        spade = 1,
        club = 2,
        heart = 3,
        diamond = 4
    },

    value =
    {
        "Ace",
        "Two",
        "Three",
        "Four",
        "Five",
        "Six",
        "Seven",
        "Eight",
        "Nine",
        "Ten",
        "Jack",
        "Queen",
        "King"
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

function card:valueToString()
    return card.config.value[self.value]
end

function card:suitToString()
    return card.config.suit[self.suit]
end

function card:toString()
    return self:valueToString().." of "..self:suitToString()
end

return card