Paddle = class{}

function Paddle:init(x, y, width, heigh)
    self.x = x
    self.y = y
    self.width = width
    self.heigh = heigh
    self.paddle_speed = 200
    self.dy = 0
end

function Paddle:reset()
    self.x = 10
    self.y = 20
end

function Paddle:update(dt)
    if self.dy > 0 then
        self.y = math.max(0, self.y - self.paddle_speed * dt)
    --elseif self.dy > VIRTUAL_HEIGH then
        --self.y = VIRTUAL_HEIGH
    else
        self.y = math.min(VIRTUAL_HEIGH - self.heigh, self.y + self.paddle_speed * dt)
    end
end

function Paddle:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.heigh)
end