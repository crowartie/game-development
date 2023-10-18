Wawe1 = {}
Wawe1.__index = Wawe1

function Wawe1:new(a, v, h, color)
    local wave = {}
    setmetatable(wave, Wawe1)
    wave.a = a
    wave.v = v
    wave.h = h
    wave.color = color
    wave.angle = 0
    return wave
end

function Wawe1:draw(x)
    local y = self.a * math.sin((self.angle + x / 240) * 4)
    y = y + self.a * math.sin((self.angle + x / 240) * 7)
    love.graphics.setColor(self.color[1], self.color[2], self.color[3])
    love.graphics.circle("line", x, y + self.h, 10)
    love.graphics.setColor((width/2)/x, 0, x/(width/2), 0.5)
    love.graphics.circle("fill", x, y + self.h, 10)
end

function Wawe1:update()
    self.angle = self.angle + self.v
end