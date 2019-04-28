Input = require('lib.boipushy.Input')

local PlayerInputManager = {
    keyActionAssociations = {
        ['left'] = 'a',
        ['right'] = 'd',
        ['soft'] = 's',
        ['hard'] = 'w',
        ['clockwise'] = 'c',
        ['counter'] = 'v',
        ['back'] = 'back'
      },
}

function PlayerInputManager:init( ) 
    self.input = Input()
    self.input:bind('mouse1', 'left_click')

    for k,v in pairs(self.keyActionAssociations) do
      self.input:bind(v,k)
    end
end

return PlayerInputManager