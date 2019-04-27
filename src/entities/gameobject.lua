Object = require('lib.classic.classic')
Timer = require('lib.chrono.Timer')
Lume = require ('lib.lume.lume')

Input = require('lib.boipushy.Input')

local GameObject = Object:extend()

function GameObject:new(x, y, opts)
    local opts = opts or {}
    if opts then for k, v in pairs(opts) do self[k] = v end end

    self.x, self.y = x, y
    --self.id = Lume.UUID()
    self.dead = false
    self.timer = Timer()
end

function GameObject:update(dt)
    if self.timer then self.timer:update(dt) end
end

function GameObject:draw()
end

return GameObject