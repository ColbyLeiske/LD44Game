local game
local menu = {}

function menu:init()
    game = require("src.states.game")
    Gamestate.switch(game)
end

function menu:draw()

end

function menu:keyreleased(key, code)
   
end

return menu