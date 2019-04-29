Gamestate = require "lib.hump.gamestate"
logger = require "src.util.logger"
Sprites = require 'src.util.spriteloader'
PlayerInputManager = require 'src.entities.playerinputmanager'

function love.load()
    logger:log("Starting up", logger.MISC)

    Sprites:loadSprites()

    leaderboard = require "src.states.leaderboard"
    game = require "src.states.game"
    menu = require "src.states.menu"

    Gamestate.registerEvents()
    PlayerInputManager:init()

    Gamestate.switch(game)
end
