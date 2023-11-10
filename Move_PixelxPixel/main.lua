-- MOVE AN ANIMATED SPRITE WITH PIXEL BY PIXEL METHOD

local player = {}
player.x = 5 * TILE_SIZE
player.y = 5 * TILE_SIZE
player.vx = 0
player.vy = 0
player.acceleration = 200 -- with a pixel precision control
player.friction = 550   -- we can have basics physics parameters 
player.maxspeed = 200  -- for more realistics (and fun) movements
player.sp_l = 1
player.sp_c = 1
player.maxframe = 9
player.SIZE = 64 
player.left_limit= 17 -- hotspots coordinates (two hotspots : hs1 and hs2)
player.top_limit = 43 -- hotspot for the top
player.right_limit = 46 -- hotspot for the right, etc.
player.bottom_limit = 63
player.head_limit = 13 -- head height
player.spritesheet = love.graphics.newImage("Player.png")
player.sprite = love.graphics.newQuad((player.sp_c-1)*player.SIZE, player.sp_l*player.SIZE, player.SIZE, player.SIZE, player.spritesheet:getDimensions())
player.anim_timer = 0.1
player.pace = 100

local grid = {}
for l = 1, N_LINE do
  grid[l] = {}
  for c = 1, N_COL do
    if love.math.random(10) < 3 then
      grid[l][c] = 1
    else
      grid[l][c] = 0
    end
  end
end

grid[math.floor(player.x / TILE_SIZE) +1 ][math.floor(player.y / TILE_SIZE) + 1] = 0


--function RepoPlayer()
--    player.x = (player.c - 1) * TILE_SIZE 
--    player.y = (player.l - 1) * TILE_SIZE 
--end


function love.load()
	

end

function walkableTile(pTile)
  -- return a boolean according to the nature of the tile (forbids or allow passage)

  if pTile > 0 then -- the tiles allowing passage should have an Id below a certain number. Here it’s zero (only two types of tile)
    return true
  else
    return false
  end

end

function getTile(pX, pY)
  -- In the Pixel x Pixel method we don’t know in advance
  -- the starting and ending points of the sprite move
  -- (controlled by the player)
  -- the collide test functions will need to test at each 
  -- update if the sprite arrives on a allowed tile, therefore
  -- has to test which tile is positionned at given coordinates

  local c = math.floor(pX / TILE_SIZE) + 1
  local l = math.floor(pY / TILE_SIZE) + 1

  return grid[l][c]

end
  


-- **************************************
-- collide test functions for each direction
-- **************************************
-- As the positionning of the sprite is precise by one pixel,
-- we have to use the hotspot method. We test two pixels on each
-- collision test we will apply on each side/direction of the sprite
-- The hotspots positions vary according to the side considered
-- and form of the sprite. Type of movement can have influence 
---for exemple,  when jumping near a tile a bad position 
-- of the hotspot can forbids jump in certain situations
-- Empiric adjustment can be needed

function collideTest(pSprite, pX1, pY1, pX2, pY2)

  local hotSpot1 = getTile(pSprite.x + pX1, pSprite.y + pY1) -- first hotspot up/right of sprite
  local hotSpot2 = getTile(pSprite.x + pX2, pSprite.y + pY2) -- second hotspot down/right

  return walkableTile(hotSpot1) or walkableTile(hotSpot2)

end


function love.update(dt)
  -- save the sprite position for repositionning
  player.x_old = player.x
  player.y_old = player.y

  -- speed update, wich sets the direction of the player
      
  if love.keyboard.isDown("up") then
    player.sp_l = 1
    player.vy = player.vy - player.acceleration * dt
    if player.vy > player.maxspeed then
      player.vy = player.maxspeed
    end

  elseif love.keyboard.isDown("right") then
    player.sp_l = 4
    player.vx = player.vx + player.acceleration * dt
    if player.vx > player.maxspeed then
      player.vx = player.maxspeed
    end

  elseif love.keyboard.isDown("down") then
    player.sp_l = 3
    player.vy = player.vy + player.acceleration * dt
    if player.vy < -player.maxspeed then
        player.vy = -player.maxspeed
    end

  elseif love.keyboard.isDown("left") then
    player.sp_l = 2
    player.vx = player.vx - player.acceleration * dt
      if player.vx < -player.maxspeed then
        player.vx = - player.maxspeed
    end
  else 
    if player.vx > 0 then
        player.vx = player.vx - player.friction * dt
        if player.vx < 0 then
          player.vx = 0
        end
    elseif player.vx < 0 then
      player.vx = player.vx + player.friction * dt
      if player.vx > 0 then
        player.vx = 0
      end
    end

    if player.vy > 0 then
      player.vy = player.vy - player.friction * dt
      if player.vy < 0 then
        player.vy = 0
      end
    elseif player.vy < 0 then
      player.vy = player.vy + player.friction * dt
      if player.vy > 0 then
        player.vy = 0
      end
    end
  end


  -- update player position according to the speed/direction
  -- if the sprite is out of the window, repositions it
  -- another technique is to create a border all around the grid and
  -- chose to not (or to) draw these border, the main collision
  -- test will stop the player at the border

  player.x = player.x + player.vx * dt
  if player.x + player.right_limit > GRID_W or player.x + player.left_limit < 0 then
    player.x = player.x_old
  end
  player.y = player.y + player.vy * dt
  if player.y + player.bottom_limit > GRID_H or player.y + player.head_limit < 0 then
    player.y = player.y_old
  end

  -- test if collision occurs
  -- collisions are tested after the player moves,
  -- it prevents glitches due to repositionning
  
  local collide = (player.vx > 0 
                    and collideTest(player, player.right_limit, player.top_limit, player.right_limit, player.bottom_limit))  -- collision Right side (top/bottom)
                  or (player.vx < 0 
                   and collideTest(player, player.left_limit, player.top_limit, player.left_limit, player.bottom_limit)) -- collision Left side (top/bottom)
  if collide == true then
    player.vx = 0
    player.x = player.x_old
    player.y = player.y_old
  end

  collide = (player.vy < 0 
              and collideTest(player, player.left_limit, player.top_limit, player.right_limit, player.top_limit)) -- collision Top (left/right)
            or (player.vy > 0 
              and collideTest(player, player.left_limit, player.bottom_limit, player.right_limit, player.bottom_limit)) -- collision Bottom (left/right)
  if collide == true then
    player.vy = 0
    player.x = player.x_old
    player.y = player.y_old
  end


  player.Animate(dt)

end


function love.draw()
  
  for i=1, N_COL - 1 do
    love.graphics.line(i*TILE_SIZE, 0, i*TILE_SIZE, GRID_H)
  end

  for i=1, N_LINE - 1 do
    love.graphics.line(0, i*TILE_SIZE, GRID_W, i*TILE_SIZE)
  end

  for l=1, N_LINE do
    for c=1, N_COL do
      if grid[l][c] == 1 then
        love.graphics.rectangle('fill', (c-1)*TILE_SIZE, (l-1)*TILE_SIZE, TILE_SIZE, TILE_SIZE)
      end
    end
  end

  --local x = (player.c-1) * TILE_SIZE 
  --local y = (player.l-1) * TILE_SIZE 
  love.graphics.draw(player.spritesheet, player.sprite, player.x, player.y)
  love.graphics.setColor(255, 0, 0)
  love.graphics.print("Player.x :"..tostring(player.x), 10, 10)
  love.graphics.print("Player.y :"..tostring(player.y), 10, 30)
  love.graphics.print("Player.c :"..tostring(player.c), 10, 50)
  love.graphics.print("Player.c_cible :"..tostring(player.c_cible), 10, 70)
  love.graphics.print("Player.l :"..tostring(player.l), 10, 90)
  love.graphics.print("Player.l_cible :"..tostring(player.l_cible), 10, 110)
  love.graphics.setColor(1, 1, 1)

end


function player.Animate(dt)

  player.anim_timer = player.anim_timer - dt
  if player.anim_timer <= 0 then
    player.anim_timer = 0.1
    player.sp_c = player.sp_c + 1
    if player.sp_c > player.maxframe then
      player.sp_c = 1
    end
  end

  player.sprite:setViewport((player.sp_c-1)*player.SIZE, (player.sp_l-1)*player.SIZE, player.SIZE, player.SIZE)

end


function love.keypressed(key)

  if key == "escape" then
    love.event.quit()
  end

end
