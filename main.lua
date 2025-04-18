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

    -- table for store multiple zombies
    zombies = {}

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

    -- zombie movement
    for i, z in ipairs(zombies) do
        z.x = z.x + (math.cos(zombiePlayerAngle(z)) * z.speed * dt)
        z.y = z.y + (math.sin(zombiePlayerAngle(z)) * z.speed * dt)
    end
end


function love.draw()
    -- draw the background to the screen
    love.graphics.draw(sprites.background, 0, 0)

    -- draw the player sprite
    love.graphics.draw(sprites.player, player.x, player.y, playerMouseAngle(), nil, nil, sprites.player:getWidth()/2, sprites.player:getHeight()/2)

    -- loop through each zombie and draw them
    for i, z in ipairs(zombies) do 
        love.graphics.draw(sprites.zombie, z.x, z.y, zombiePlayerAngle(z), nil, nil, sprites.player:getWidth()/2, sprites.player:getHeight()/2)
    end
end

-- function to spawn zombies when spacebar is pressed
function love.keypressed(key)
    if key == "space" then
        spawnZombie()
    end
end

-- calculate angle between mouse and the sprite(radiant)
function playerMouseAngle() 
    return math.atan2(player.y - love.mouse.getY(), player.x - love.mouse.getX()) + math.pi
end

-- note
-- get player sprite size half to center offset 

 -- find the angle between player and the zombie
function zombiePlayerAngle(enemy) 
    return math.atan2(player.y - enemy.y, player.x - enemy.x)
end

function spawnZombie()
    -- table for store individual zombie
    local zombie = {}
    zombie.x = math.random(0, love.graphics.getWidth())
    zombie.y = math.random(0, love.graphics.getHeight())
    zombie.speed = 140
    
    -- add single zombie to the zombies table
    table.insert(zombies, zombie)
end

-- calculate distance between player and the zombie
-- function distanceBetween(x1, y1, x2, y2)
--     return math.sqrt( (x2 - x1)^2 + (y2-y1)^2 )
-- end
