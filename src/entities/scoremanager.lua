
local ScoreManager = {}

function ScoreManager:init( )
    print("ScoreManager init")
    self.score = 0
    self.multiplier = 1
end

function ScoreManager:clearedLine()
    self.score = self.score + (1*self.multiplier)
    print("Cleared a line! New Score is " .. self.score)
end

function ScoreManager:setMultiplier(multiplier)
    self.multiplier = multiplier
end

return ScoreManager