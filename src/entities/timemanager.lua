local TimeManager = {}

function TimeManager:init( )
    self.time = 90
    self.multiplier = 1
end

function TimeManager:clearedLine()
    self.time = self.time + (5*self.multiplier)
    print("Cleared a line! New time is " .. self.time)
end

function TimeManager:setMultiplier(multiplier)
    self.multiplier = multiplier
end

return TimeManager