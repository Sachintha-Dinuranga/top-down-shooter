function love.load()

    -- random seed (current time)
    math.randomseed(os.time())

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

    -- new font
    myFont = love.graphics.newFont(40)

    -- table for store multiple zombies
    zombies = {}

    -- table for store all the bullet objects
    bullets = {}

    --game state (1-main menu, 2 - gameplay)
    gameState = 1
    score = 0
    maxTime = 2
    timer = maxTime
end


function love.update(dt)
    if gameState == 2 then
        -- adding player movement
        if love.keyboard.isDown("d") and player.x < love.graphics.getWidth() then
            player.x = player.x + player.speed * dt
        end
        if love.keyboard.isDown("a") and player.x > 0 then
            player.x = player.x - player.speed * dt
        end
        if love.keyboard.isDown("s") and player.y < love.graphics.getHeight() then
            player.y = player.y + player.speed * dt
        end
        if love.keyboard.isDown("w") and player.y > 0 then
            player.y = player.y - player.speed * dt
        end
    end
    -- zombie movement
    for i, z in ipairs(zombies) do
        z.x = z.x + (math.cos(zombiePlayerAngle(z)) * z.speed * dt)
        z.y = z.y + (math.sin(zombiePlayerAngle(z)) * z.speed * dt)

        if distanceBetween(z.x, z.y, player.x, player.y) < 30 then
            for i , z in ipairs(zombies) do
                zombies[i] = nil
                gameState = 1
                player.x = love.graphics.getWidth()/2
                player.y = love.graphics.getHeight()/2
            end
        end
    end

    -- bullet movement
    for i, b in ipairs(bullets) do
        b.x = b.x + (math.cos(b.direction) * b.speed * dt)
        b.y = b.y + (math.sin(b.direction) * b.speed * dt)
    end

    -- remove items from the bullets table
    for i=#bullets, 1, -1 do
        local b = bullets[i]
        -- check whether bullets are out of bound
        if b.x < 0 or b.y < 0 or b.x > love.graphics.getWidth() or b.y > love.graphics.getHeight() then
            table.remove(bullets, i)
        end
    end

    -- compare every zombie to every bullet
    for i,z in ipairs(zombies) do 
        for j, b in ipairs(bullets) do 
            -- check for collison between zombie and the bullet
            if distanceBetween(z.x, z.y, b.x, b.y) < 20 then
                z.dead = true
                b.dead = true
                score = score + 1
            end
        end
    end

    -- iterate through the zombies and remove them if they are dead
    for i=#zombies, 1, -1 do
        local z = zombies[i]
        if z.dead == true then
            table.remove(zombies, i)
        end
    end

    -- iterate through the bullets and remove them if they are dead
    for i=#bullets, 1, -1 do
        local b = bullets[i]
        if b.dead == true then
            table.remove(bullets, i)
        end
    end

    -- enemy spawn timer
    if gameState == 2 then
        timer = timer - dt
        if timer <= 0 then
            spawnZombie()
            maxTime = 0.95 * maxTime
            timer = maxTime
        end
    end
end


function love.draw()
    -- draw the background to the screen
    love.graphics.draw(sprites.background, 0, 0)

    -- main menu
    if gameState == 1 then
        love.graphics.setFont(myFont)
        love.graphics.printf("Click anywhere to begin!", 0, 50, love.graphics.getWidth(), "center")
    end

    -- score
    love.graphics.printf("Score: " .. score, 0, love.graphics.getHeight() - 100, love.graphics.getWidth(), "center")

    -- draw the player sprite
    love.graphics.draw(sprites.player, player.x, player.y, playerMouseAngle(), nil, nil, sprites.player:getWidth()/2, sprites.player:getHeight()/2)

    -- loop through each zombie and draw them
    for i, z in ipairs(zombies) do 
        love.graphics.draw(sprites.zombie, z.x, z.y, zombiePlayerAngle(z), nil, nil, sprites.player:getWidth()/2, sprites.player:getHeight()/2)
    end

    -- loop through each bullet and draw them
    for i, b in ipairs(bullets) do
        love.graphics.draw(sprites.bullet, b.x, b.y, nil, 0.5, 0.5, sprites.bullet:getWidth()/2, sprites.bullet:getHeight()/2)
    end
end

-- function to spawn zombies when spacebar is pressed
function love.keypressed(key)
    if key == "space" then
        spawnZombie()
    end
end

-- shooting bullets
function love.mousepressed(x, y, button)
    if button == 1 and gameState == 2 then
        spawnBullet()
    elseif button == 1 and gameState == 1 then
        gameState = 2
        maxTime = 2
        timer = maxTime
        score = 0
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
    zombie.speed = 105
    zombie.dead = false
    -- add single zombie to the zombies table
    table.insert(zombies, zombie)
    
end

-- function for spawn bullets
function spawnBullet()
    local bullet = {}
    bullet.x = player.x
    bullet.y = player.y
    bullet.speed = 500
    bullet.dead = false
    bullet.direction = playerMouseAngle()
    table.insert(bullets, bullet)
end

-- calculate distance between player and the zombie
function distanceBetween(x1, y1, x2, y2)
    return math.sqrt( (x2 - x1)^2 + (y2-y1)^2 )
end
