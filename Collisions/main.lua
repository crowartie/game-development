require "wave1"
require "wave2"

function love.load()
    width = love.graphics.getWidth()
    height = love.graphics.getHeight()
    wave1 = Wawe1:new(20, 0.005, height-50, {1, 1, 1})
    wave2 = Wawe2:new(20, 0.005, height-50, {1, 1, 1})
end

function love.update()
    wave1:update()
    wave2:update()
end

function love.draw()
    for x = 0, width/3, 8 do
        wave1:draw(x)
    end

    for x = 0, width/3, 8 do
        wave2:draw(x)
    end
end
