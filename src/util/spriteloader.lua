local spriteloader = {
    hasLoaded = false
}

function spriteloader:loadSprites()
    if self.hasLoaded == true then return end
    love.graphics.setDefaultFilter('nearest','nearest',1)
    self.blueBlock = love.graphics.newImage("res/raw_sprites/png/tetrisblockblue.png")
    self.leaderboard = love.graphics.newImage("res/raw_sprites/png/leaderboard.png")
    self.hasLoaded = true
end

return spriteloader