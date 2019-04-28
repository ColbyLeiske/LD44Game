Gamestate = require "lib.hump.gamestate"
logger = require "src.util.logger"
Sprites = require 'src.util.spriteloader'
function love.load()
    logger:log("Starting up", logger.MISC)

    Sprites:loadSprites()

    leaderboard = require "src.states.leaderboard"
    game = require "src.states.game"

    Gamestate.registerEvents()
    Gamestate.switch(game)
end

