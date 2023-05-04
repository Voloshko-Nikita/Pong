WINDOW_WIDTH = 1280
WINDOW_HEIGH = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGH = 243

paddle_speed = 200


push = require 'push'

class = require 'class'

require 'Ball'

require 'Paddle'

gameState = "Start"

sounds = {
    ['paddle_hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
    ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
    ['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static')
}

function love.load()

    love.window.setTitle('Pong')

    love.graphics.setDefaultFilter('nearest', 'nearest')

    smallFont = love.graphics.newFont("font.ttf", 8)
    scoreFont = love.graphics.newFont("font.ttf", 32)

    math.randomseed(os.time())

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGH, WINDOW_WIDTH, WINDOW_HEIGH,{
        fullscreen = false,
        resizable = true,
        vsync = true
    })

    Player1 = 0
    Player2 = 0

    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGH / 2 - 2, 4, 4)

    PlayerY1 = Paddle(10, 30, 5, 20)
    PlayerY2 = Paddle(VIRTUAL_WIDTH-20, VIRTUAL_HEIGH-50, 5, 20)

    servingPlayer = 1

end


function love.resize(w, h)
    push:resize(w, h)    
end


function love.draw()
    push:apply('start')
        love.graphics.clear(40/255, 45/255, 52/255, 255/255)

        love.graphics.setFont(smallFont)

        love.graphics.setFont(scoreFont)
        love.graphics.print(tostring(Player1),VIRTUAL_WIDTH/2-50,VIRTUAL_HEIGH/3)
        love.graphics.print(tostring(Player2),VIRTUAL_WIDTH/2+30,VIRTUAL_HEIGH/3)
        
        if gameState == 'Start' then
            love.graphics.setFont(smallFont)
            love.graphics.printf('Welcome to Pong!', 0, 10, VIRTUAL_WIDTH, 'center')
            love.graphics.printf('Press Enter to begin!', 0, 20, VIRTUAL_WIDTH, 'center')
        elseif gameState == 'serve' then
            love.graphics.setFont(smallFont)
            love.graphics.printf('Player ' .. tostring(servingPlayer) .. "'s serve!", 
                0, 10, VIRTUAL_WIDTH, 'center')
            love.graphics.printf('Press Enter to serve!', 0, 20, VIRTUAL_WIDTH, 'center')
        elseif gameState == 'play' then
            -- no UI messages to display in play
        elseif gameState == 'done' then
            -- UI messages
            love.graphics.setFont(scoreFont)
            love.graphics.printf('Player ' .. tostring(winningPlayer) .. ' wins!',
                0, 10, VIRTUAL_WIDTH, 'center')
            love.graphics.setFont(smallFont)
            love.graphics.printf('Press Enter to restart!', 0, 47, VIRTUAL_WIDTH, 'center')
        end

        ball:render()
        PlayerY1:render()
        PlayerY2:render()

        --love.graphics.print(tostring(ball.y))
        displayFPS()

    push:apply('end')
end


function love.update(dt)
    if love.keyboard.isDown("w") then
        PlayerY1.dy = 1
        PlayerY1:update(dt)
    elseif love.keyboard.isDown("s") then
        PlayerY1.dy = 0
        PlayerY1:update(dt)
    end
    
    if love.keyboard.isDown("up") then
        PlayerY2.dy = 1
        PlayerY2:update(dt)
    elseif love.keyboard.isDown("down") then
        PlayerY2.dy = 0
        PlayerY2:update(dt)
    end
    if gameState =="serve" then
        ball.dy = math.random(-50,50)
        if servingPlayer == 1 then
            message = 'Serving, serving person is Player 1'
            ball.dx = math.random(140, 200)
        else
            message = 'Serving, serving person is Player 2'
            ball.dx = -math.random(140, 200)
        end
    end

    if gameState =="Play" then
        ball:update(dt)
        PlayerY1.y = ball.y - 4
        if ball.x > VIRTUAL_WIDTH then
            ball:reset()
            Player1 = Player1 + 1
            servingPlayer = 2
            sounds['score']:play()
            if Player1 == 10 then
                gameState = 'done'
                winningPlayer = 1
            else
                gameState = 'serve'
            end
        elseif ball.x < 0 then
            ball:reset()
            Player2 = Player2 + 1
            servingPlayer = 1
            sounds['score']:play()
            if Player2 == 10 then
                gameState = 'done'
                winningPlayer = 2
            else
                gameState = 'serve'
            end
        end

        if ball:collaides(PlayerY1) then
            ball.dx = - ball.dx * 1.05
            ball.x = PlayerY1.x + 5
            sounds['paddle_hit']:play()
            if ball.dy>=0 then
                ball.dy = math.random(10,120)
            else
                ball.dy = -math.random(10,120)
            end
        elseif ball:collaides(PlayerY2) then
            ball.dx = - ball.dx * 1.05
            ball.x = PlayerY2.x - 4
            sounds['paddle_hit']:play()
            if ball.dy>=0 then
                ball.dy = math.random(10,120)
            else
                ball.dy = -math.random(10,120)
            end
        end

        if ball.y <= 0 then
            ball.y = 0
            ball.dy = - ball.dy
            sounds['wall_hit']:play()
        elseif ball.y >= VIRTUAL_HEIGH - ball.heigh then
            ball.y = VIRTUAL_HEIGH - ball.heigh
            ball.dy = - ball.dy
            sounds['wall_hit']:play()
        end
    end
end



function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
    if key == "space" then
        if gameState == "Start"then
            gameState = "serve"
        elseif gameState == 'done' then
            gameState = "serve"
            ball:reset()
            Player1 = 0
            Player2 = 0

            if winningPlayer == 1 then
                servingPlayer = 2
            else
                servingPlayer = 1                
            end
        else
            gameState = "Play"
        end
    end
end

function displayFPS()
    love.graphics.setFont(smallFont)  
    love.graphics.setColor(0/255, 255/255, 0/255, 255/255)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 20, 10)  
end
