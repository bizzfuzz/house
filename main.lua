Class = require 'libs.class'
require 'program'
function love.load()
    love.graphics.setBackgroundColor(150, 140,140)
    program = Program()
end

function love.update(dt)
    program:update()
end

function love.draw()
    program:draw()
end

function love.textinput(t)
    program:textinput(t)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.push('quit')
    elseif key == ' ' then
        love.load()
    end
    program:keypressed(key)
end

function love.keyreleased(key)
--    program:keyreleased(key)
end

function love.mousepressed(x,y,button)
    program:mousepressed(x,y,button)
end

function love.mousereleased(x,y,button)
--    program:mousereleased(x,y,button)
end

function love.wheelmoved(x,y)
    program:wheelmoved(x,y)
end

box = function(x,y,w,h)
    love.graphics.setColor(40,40,45)
    love.graphics.rectangle('fill', x,y,w,h)
    love.graphics.setColor(255,255,255)
end

rbox = function(x,y,w,h)
    love.graphics.setColor(140,80,85)
    love.graphics.rectangle('fill', x,y,w,h)
    love.graphics.setColor(255,255,255)
end
colliding = function(x,y, thing)
    if x <= thing.x+thing.width and x >= thing.x then
        if y <= thing.y+thing.height and y >= thing.y then
            return true
        end
    end
    return false
end
