function love.load()
    -- load the sprites
    sprites = {}
    sprites.background = love.graphics.newImage('sprites/background.png')
    sprites.player = love.graphics.newImage('sprites/player.png')
    sprites.bullet = love.graphics.newImage('sprites/bullet.png')
    sprites.zombie = love.graphics.newImage('sprites/zombie.png')

    -- load the player and config
    player = {}
    player.x = love.graphics.getWidth() / 2
    player.y = love.graphics.getHeight() / 2
    
end


function love.update(dt)

end


function love.draw()
    -- draw the background to the screen
    love.graphics.draw(sprites.background, 0, 0)

    -- draw the player sprite
    love.graphics.draw(sprites.player, player.x, player.y)
end