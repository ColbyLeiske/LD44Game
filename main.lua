Gamestate = require "lib.hump.gamestate"
logger = require "src.util.logger"

function love.load()
    logger:log("Starting up", logger.MISC)
    menu = require "src.states.menu"
    game = require "src.states.game"
    --leaderboard = require "src.states.leaderboard"

    Gamestate.registerEvents()
    Gamestate.switch(game)
end

