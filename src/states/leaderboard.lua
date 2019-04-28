
Dreamlo = require 'lib.dreamlo.dreamlo'
Sprites = require 'src.util.spriteloader'
http = require "socket.http"
json = require "lib.json.json"
sprites = require 'src.util.spriteloader'
Colors = require 'src.util.colors'

local leaderboard = {}

function leaderboard:enter()
    logger:log("Starting Leaderboard Intialization")
    logger:log("Leaderboard Initialized")

    sprites:loadSprites()

    Dreamlo.setSecretCode(dreamlo_secret)
    Dreamlo.setPublicCode(dreamlo_public)
    result, status, content = http.request("http://dreamlo.com/lb/5cc4db093eba951290f33d28/json")

    self.noConnection = status ~= 200
    self.leaderboard = {}
    if self.noConnection == false then
        self.leaderboard = json.decode(result).dreamlo.leaderboard.entry
    end

    for k,v in pairs(self.leaderboard) do
        print(v.name .. " - " .. v.score)
    end
    self.font = love.graphics.newFont("res/fonts/goodbyeDespair.ttf", 20) -- the number denotes the font size
    love.graphics.setFont(self.font)

    self.topBannerHeight = 135

end

function leaderboard:update(dt)
   
end

function leaderboard:draw()
    love.graphics.setColor(Colors.darkGreen)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), self.topBannerHeight)

    love.graphics.setColor(Colors.lightBrown)
    love.graphics.rectangle("fill", 0, self.topBannerHeight, love.graphics.getWidth()/2, love.graphics.getHeight())

    love.graphics.setColor(Colors.lightBrown)
    love.graphics.rectangle("fill", love.graphics.getWidth()/2, self.topBannerHeight, love.graphics.getWidth()/2, love.graphics.getHeight())

    love.graphics.draw(sprites.leaderboard,(love.graphics.getWidth()) - (sprites.leaderboard:getWidth()),50,0,.95,.95)
    local i = 1
    for k,v in pairs(self.leaderboard) do
        local nameWidth = self.font:getWidth(v.name)
        local scoreWidth = self.font:getWidth(v.score)

        love.graphics.setColor(Colors.darkPurple)
        love.graphics.print(i .. " " .. v.name, (love.graphics.getWidth()/2) - nameWidth - 60, 125 + (i*40))
        love.graphics.print(v.score, (love.graphics.getWidth()/2) - scoreWidth + 115, 125 + (i * 40))
        i = i + 1
    end

    love.graphics.setColor(210/255, 255/255, 248/255)

    gold = love.graphics.newImage("res/trophies/goldtrophy.jpg")
    love.graphics.draw(gold, love.graphics.getWidth()/2-30, 165,0, .015, .015)

    silver = love.graphics.newImage("res/trophies/2ndtrophy.jpg")
    love.graphics.draw(silver, love.graphics.getWidth()/2-30, 205,0, .015, .015)

    bronze = love.graphics.newImage("res/trophies/3rdtrophy.jpg")
    love.graphics.draw(bronze, love.graphics.getWidth()/2-30, 245,0, .015, .015)

end

function leaderboard:keypressed(key) 
   if key == 'q' then
    love.event.quit()
   end
end

return leaderboard