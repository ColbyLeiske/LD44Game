local TimeManager = {}

function TimeManager:init( )
    print("TimeManager init")
    self.time = 60
end

function TimeManager:clearedLine()
    self.time = self.time + 5
    print("Cleared a line! New time is " .. self.time)
end

return TimeManager