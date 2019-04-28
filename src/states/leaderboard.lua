
Dreamlo = require 'lib.dreamlo.dreamlo'
Sprites = require 'src.util.spriteloader'
http = require "socket.http"
json = require "lib.json.json"
sprites = require 'src.util.spriteloader'

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
    self.font = love.graphics.newFont(14) -- the number denotes the font size
    love.graphics.setFont(self.font)

end

function leaderboard:update(dt)
   
end

function leaderboard:draw()
    love.graphics.draw(sprites.leaderboard,(love.graphics.getWidth()/2) - (sprites.leaderboard:getWidth()),50,0,2,2)
    local i = 1
    for k,v in pairs(self.leaderboard) do
        local nameWidth = self.font:getWidth(v.name)
        local scoreWidth = self.font:getWidth(v.score)

        love.graphics.print(v.name, (love.graphics.getWidth()/2) - nameWidth - 75, 125 + (i*40))
        love.graphics.print(v.score, (love.graphics.getWidth()/2) - scoreWidth + 75, 125 + (i * 40))
        i = i + 1
    end

end

function leaderboard:keypressed(key) 
   if key == 'q' then
    love.event.quit()
   end
end

return leaderboard