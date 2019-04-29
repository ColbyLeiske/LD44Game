local AudioManager = {
    volume = .6
}

function AudioManager:init( )
    print("AudioManager init")
    self.tetristheme = love.audio.newSource('res/audio/tetrisTheme.ogg', 'stream')
    self.plop = love.audio.newSource('res/audio/plop.wav', 'static')
	self.pling = love.audio.newSource('res/audio/pling.mp3', 'static')
	self.coins = love.audio.newSource('res/audio/coins.wav', 'static')
    self.chaching = love.audio.newSource('res/audio/chaching.wav', 'static')
    love.audio.setVolume(self.volume)

end

function AudioManager:clearedLine()
    love.audio.play(self.coins)
end

function AudioManager:tetrisclear()
    love.audio.play(self.chaching)
end

function AudioManager:playtheme()
	love.audio.play(self.tetristheme)
end

function AudioManager:playGameover()
	love.audio.stop()
end

function AudioManager:mute() 
    love.audio.setVolume(0)
end

function AudioManager:clickedVolumeIcon()
    if self.volume == 1 then
        self.volume = .6
    elseif self.volume == .6 then
        self.volume = .3
    elseif self.volume == .3 then
        self.volume = 0
    elseif self.volume == 0 then
        self.volume = 1
    end

    love.audio.setVolume(self.volume)
end

return AudioManager