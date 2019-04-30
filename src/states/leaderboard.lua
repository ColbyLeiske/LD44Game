
Dreamlo = require 'lib.dreamlo.dreamlo'
Sprites = require 'src.util.spriteloader'
PlayerInputManager = require 'src.entities.playerinputmanager'

http = require "socket.http"
json = require "lib.json.json"
sprites = require 'src.util.spriteloader'
GameState = require 'lib.hump.gamestate'
menu = require 'src.states.menu'

local leaderboard = {}

function leaderboard:enter(from)
    logger:log("Starting Leaderboard Intialization")
    logger:log("Leaderboard Initialized")

    Dreamlo.setSecretCode(dreamlo_secret)
    Dreamlo.setPublicCode(dreamlo_public)
    result, status, content = http.request("http://dreamlo.com/lb/5cc4db093eba951290f33d28/json")

    self.noConnection = status ~= 200
    self.leaderboard = {}
    if self.noConnection == false then
        self.leaderboard = json.decode(result).dreamlo.leaderboard.entry
    end
    
    self.font = love.graphics.newFont("res/fonts/goodbyeDespair.ttf", 8) -- the number denotes the font size
    love.graphics.setFont(self.font)

    self.from = from

end

function leaderboard:update(dt)
    if PlayerInputManager.input:pressed('left_click') then
        
    local mousex, mousey = love.mouse.getPosition()
    print(mousex .. " " .. mousey)
        if isInBounds(289,566,418,600) then
            GameState.switch(self.from)
        end
    end
end

function leaderboard:draw()
    love.graphics.scale(4,4)
    love.graphics.draw(sprites.scoresbackground,0,0)
    love.graphics.print("Back",288/4 + 7,512/4 + 14.5 )

    local i = 1
    for k,v in pairs(self.leaderboard) do
        if i == 10 then
            return
        end
        local nameWidth = self.font:getWidth(v.name)
        local scoreWidth = self.font:getWidth(v.score)

        love.graphics.print(i .. " " .. v.name, 52.5,45+(i*8))
        love.graphics.print(v.score, 110,45+(i*8))
        i = i + 1
    end


    -- gold = love.graphics.newImage("res/trophies/goldtrophy.jpg")
    -- love.graphics.draw(gold, love.graphics.getWidth()/2-30, 165,0, .015, .015)

    -- silver = love.graphics.newImage("res/trophies/2ndtrophy.jpg")
    -- love.graphics.draw(silver, love.graphics.getWidth()/2-30, 205,0, .015, .015)

    -- bronze = love.graphics.newImage("res/trophies/3rdtrophy.jpg")
    -- love.graphics.draw(bronze, love.graphics.getWidth()/2-30, 245,0, .015, .015)

end

function isInBounds(x1,y1,x2,y2)
    local mousex, mousey = love.mouse.getPosition()
    return mousex > x1 and mousex < x2 and mousey > y1 and mousey < y2
end


return leaderboard
