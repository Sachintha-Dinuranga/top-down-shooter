function love.load()

    -- load the sprites
    sprites = {}
    sprites.background = love.graphics.newImage('sprites/background.png')
    sprites.player = love.graphics.newImage('sprites/player.png')
    sprites.bullet = love.graphics.newImage('sprites/bullet.png')
    sprites.zombie = love.graphics.newImage('sprites/zombie.png')

    -- player config
    player = {}
    player.x = love.graphics.getWidth() / 2
    player.y = love.graphics.getHeight() / 2
    player.speed = 180 -- 180 because frame rates 1/60 * 180 = 3

    -- rotation value
    tempRotation = 0
end


function love.update(dt)
    -- adding player movement
    if love.keyboard.isDown("d") then
        player.x = player.x + player.speed * dt
    end
    if love.keyboard.isDown("a") then
        player.x = player.x - player.speed * dt
    end
    if love.keyboard.isDown("s") then
        player.y = player.y + player.speed * dt
    end
    if love.keyboard.isDown("w") then
        player.y = player.y - player.speed * dt
    end

    tempRotation = tempRotation + 0.01
end


function love.draw()
    -- draw the background to the screen
    love.graphics.draw(sprites.background, 0, 0)

    -- draw the player sprite
    love.graphics.draw(sprites.player, player.x, player.y, tempRotation, nil, nil, sprites.player:getWidth()/2, sprites.player:getHeight()/2)
end




-- note
-- get player sprite size half to center offset  