local AudioManager = {}

function AudioManager:init( )
    print("AudioManager init")
    self.tetristheme = love.audio.newSource('res/audio/tetrisThemeLooped.mp3', 'stream')
    self.plop = love.audio.newSource('res/audio/plop.wav', 'static')
	self.pling = love.audio.newSource('res/audio/pling.mp3', 'static')
	self.coins = love.audio.newSource('res/audio/coins.wav', 'static')
	self.chaching = love.audio.newSource('res/audio/chaching.wav', 'static')

end

function AudioManager:clearedLine()
    love.audio.play(self.coins)
end

function AudioManager:tetrisclear()
    love.audio.play(self.chaching)
end

function AudioManager:playtheme()
	love.audio.play(self.tetristheme,self.tetristheme,self.tetristheme,self.tetristheme,self.tetristheme)
end

function AudioManager:playGameover()
	love.audio.stop()
end

return AudioManager