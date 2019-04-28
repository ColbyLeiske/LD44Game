Gamestate = require "lib.hump.gamestate"
logger = require "src.util.logger"

function love.load()
    logger:log("Starting up", logger.MISC)
    leaderboard = require "src.states.leaderboard"
    game = require "src.states.game"

    Gamestate.registerEvents()
    Gamestate.switch(leaderboard)
end

