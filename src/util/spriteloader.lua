local spriteloader = {
    hasLoaded = false
}

function spriteloader:loadSprites()
    if self.hasLoaded == true then return end
    love.graphics.setDefaultFilter('nearest','nearest',1)
    self.blueBlock = love.graphics.newImage("res/raw_sprites/png/tetrisblockblue.png")
    self.brownBlock = love.graphics.newImage("res/raw_sprites/png/tetrisblockbrown.png")
    self.greenBlock = love.graphics.newImage("res/raw_sprites/png/tetrisblockgreen.png")
    self.lightBlueBlock = love.graphics.newImage("res/raw_sprites/png/tetrisblocklightblue.png")
    self.oliveBlock = love.graphics.newImage("res/raw_sprites/png/tetrisblockolive.png")
    self.redBlock = love.graphics.newImage("res/raw_sprites/png/tetrisblockred.png")
    self.tanBlock = love.graphics.newImage("res/raw_sprites/png/tetrisblocktan.png")
    self.greyBlock = love.graphics.newImage("res/raw_sprites/png/tetrisblockgrey.png")

    self.leaderboard = love.graphics.newImage("res/raw_sprites/png/leaderboard.png")
    self.gamebackground = love.graphics.newImage('res/raw_sprites/png/gamebackground.png')
    self.pausemenu = love.graphics.newImage('res/raw_sprites/png/pausemenu.png')
    self.pausebutton = love.graphics.newImage('res/raw_sprites/png/pausebutton.png')
    self.gameoverbackground = love.graphics.newImage('res/raw_sprites/png/gameoverbackground.png')
    self.gameoverbutton = love.graphics.newImage('res/raw_sprites/png/gameoverbutton.png')
    
    self.volumeicon = love.graphics.newImage('res/raw_sprites/png/volumeicon.png')
    self.volumewave1 = love.graphics.newImage('res/raw_sprites/png/volumewave1.png')
    self.volumewave2 = love.graphics.newImage('res/raw_sprites/png/volumewave2.png')
    self.volumewave3 = love.graphics.newImage('res/raw_sprites/png/volumewave3.png')

    self.menubackground = love.graphics.newImage('res/raw_sprites/png/menubackground.png')
    self.keybindsbackground = love.graphics.newImage('res/raw_sprites/png/keybindsbackground.png')
    self.scoresbackground = love.graphics.newImage('res/raw_sprites/png/scoresbackground.png')

    self.hasLoaded = true
end

return spriteloader