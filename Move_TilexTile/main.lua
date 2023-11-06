-- MOVE AN ANIMATED SPRITE WITH TILE BY TILE METHOD
-- 

local player = {}
player.l = 10
player.c = 10
player.moving = false
player.sp_l = 1
player.sp_c = 1
player.maxframe = 9
player.SIZE = 64 
player.spritesheet = love.graphics.newImage("Player.png")
player.sprite = love.graphics.newQuad((player.sp_c-1)*player.SIZE, player.sp_l*player.SIZE, player.SIZE, player.SIZE, player.spritesheet:getDimensions())
player.anim_timer = 0.1

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

grid[player.l][player.c] = 0

function love.update(dt)
  
  if love.keyboard.isDown("up", "right", "down", "left") then
    if player.moving == false then

      if love.keyboard.isDown("up") then
        player.sp_l = 1
        if player.l > 1 then
          if grid[player.l-1][player.c] == 0 then
            player.l = player.l -1
          end
        end
      end

      if love.keyboard.isDown("right") then
        player.sp_l = 4
        if player.c < N_COL then
          if grid[player.l][player.c+1] == 0 then
            player.c = player.c + 1
          end
        end
      end

      if love.keyboard.isDown("down") then
        player.sp_l = 3
        if player.l < N_LINE then
          if grid[player.l+1][player.c] == 0 then
            player.l = player.l + 1
          end
        end
      end

      if love.keyboard.isDown("left") then
        player.sp_l = 2
        if player.c > 1 then
          if grid[player.l][player.c-1] == 0 then
            player.c = player.c - 1
          end
        end
      end
    
      player.moving = true 
    end

  else
    player.moving = false
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
  
  local x = (player.c-1) * TILE_SIZE 
  local y = (player.l-1) * TILE_SIZE 
  love.graphics.draw(player.spritesheet, player.sprite, x, y)
  love.graphics.setColor(255, 0, 0)
  love.graphics.print("x :"..tostring(x), 10, 10)
  love.graphics.print("y :"..tostring(y), 10, 30)
  love.graphics.print("Player.c :"..tostring(player.c), 10, 50)
  love.graphics.print("Player.l :"..tostring(player.l), 10, 70)
  love.graphics.print("Player.moving :"..tostring(player.moving), 10, 90)
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
