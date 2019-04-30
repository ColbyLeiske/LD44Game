Gamestate = require "lib.hump.gamestate"
logger = require "src.util.logger"
Sprites = require 'src.util.spriteloader'
PlayerInputManager = require 'src.entities.playerinputmanager'

function love.load()
    --logger:log("Starting up", logger.MISC)
    print("Not sure why the console opens... If you know how to fix it, please let us know!")
    print("Our conf.lua has the console set to false, and it does not open in the dev environment.")
    print("Additionally, if you know why a fused Love2D game can't read the internal .exe filesystem and requires us to package our code and libraries..")
    print("We would love to know!")
    
    Sprites:loadSprites()

    leaderboard = require "src.states.leaderboard"
    game = require "src.states.game"
    menu = require "src.states.menu"

    Gamestate.registerEvents()
    PlayerInputManager:init()

    Gamestate.switch(menu)
end
