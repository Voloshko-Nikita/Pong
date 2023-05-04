

Ball = class{}

function Ball:init(x, y, width, heigh)
    self.x = x
    self.y = y
    self.width = width
    self.heigh = heigh

    self.dx = math.random(2) == 1 and 100 or -100
    self.dy = math.random(-50,50)
end

function Ball:reset()
    self.x = VIRTUAL_WIDTH / 2 - 2    
    self.y = VIRTUAL_HEIGH / 2 - 2 
    self.dx = math.random(2) == 1 and 100 or -100
    self.dy = math.random(-50,50)   
end

function Ball:update(dt)
    self.x = self.x + self.dx *dt    
    self.y = self.y + self.dy *dt  
end

function Ball:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.heigh)
end

function Ball:collaides(paddle)
    if self.x > paddle.x + paddle.width or paddle.x > self.x + self.width then
        return false
    end 
    if self.y > paddle.y + paddle.heigh or paddle.y > self.y + self.heigh then
        return false 
    end
    return true
end