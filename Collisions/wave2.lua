Wawe2 = {}
Wawe2.__index = Wawe2

function Wawe2:new(a, v, h, color)
    local wave = {}
    setmetatable(wave, Wawe2)
    wave.a = a
    wave.v = v
    wave.h = h
    wave.color = color
    wave.angle = 0
    return wave
end

function Wawe2:draw(x)
    local y = self.a * math.cos((self.angle + x / 240) * 4)
    y = y + self.a * math.cos((self.angle + x / 240) * 7)
    love.graphics.setColor(self.color[1], self.color[2], self.color[3])
    love.graphics.circle("line", width - x, height - (y + self.h), 10)
    love.graphics.setColor((width/2)/(width-x), 0, (width-x)/(width/2), 0.5)
    love.graphics.circle("fill", width - x, height - (y + self.h), 10)
end

function Wawe2:update()
    self.angle = self.angle + self.v
end
