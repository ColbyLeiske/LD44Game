beholder = require 'lib.beholder.beholder'

local ScoreManager = {}

function ScoreManager:init( )
    print("ScoreManager init")
    self.score = 0
end

function ScoreManager:clearedLine()
    self.score = self.score + 1
    print("Cleared a line! New Score is " .. self.score)
end

return ScoreManager