-- Screen size (128x64 for jumper t pro v2)
local SCREEN_W = 128
local SCREEN_H = 64

-- Tuning values
local PADDLE_HEIGHT = 20
local PADDLE_SPEED  = 3
local BALL_SIZE     = 3

-- Paddle state
local leftPaddleY = math.floor((SCREEN_H - PADDLE_HEIGHT) / 2)
local rightPaddleY = math.floor((SCREEN_H - PADDLE_HEIGHT) / 2)

-- Ball state
local ballX = math.floor(SCREEN_W / 2)
local ballY = math.floor(SCREEN_H / 2)
local ballVX = 2
local ballVY = 1

local score = 0

-- Reset ball to center and send it the other way
local function resetBall()
  ballX = math.floor(SCREEN_W / 2)
  ballY = math.floor(SCREEN_H / 2)
  ballVX = -ballVX
end

-- Keep a value inside screen bounds
local function clamp(value, min, max)
  if value < min then return min end
  if value > max then return max end
  return value
end

-- Handle stick input
local function handleInput(event)
  -- Left stick up/down controls left paddle (throttle)
  local leftStick = getValue("thr")
  leftPaddleY = leftPaddleY - (leftStick / 300)  -- Negative so up is up
  leftPaddleY = clamp(leftPaddleY, 0, SCREEN_H - PADDLE_HEIGHT)
  
  -- Right stick up/down controls right paddle (elevator)
  local rightStick = getValue("ele")
  rightPaddleY = rightPaddleY - (rightStick / 300)  -- Negative so up is up
  rightPaddleY = clamp(rightPaddleY, 0, SCREEN_H - PADDLE_HEIGHT)
end

-- Update ball position and collisions
local function updateBall()
  ballX = ballX + ballVX
  ballY = ballY + ballVY

  -- Bounce off top and bottom
  if ballY <= 0 or ballY >= SCREEN_H then
    ballVY = -ballVY
  end



  -- Left paddle collision
  if ballX <= 6 then
    if ballY >= leftPaddleY and ballY <= leftPaddleY + PADDLE_HEIGHT then
      ballVX = -ballVX
      score = score + 1
    else
      score = 0
      resetBall()
    end
  end
  
  -- Right paddle collision
  if ballX >= SCREEN_W - 6 then
    if ballY >= rightPaddleY and ballY <= rightPaddleY + PADDLE_HEIGHT then
      ballVX = -ballVX
      score = score + 1
    else
      score = 0
      resetBall()
    end
  end
end

-- Draw everything
local function draw()
  lcd.clear()

  -- Draw left paddle
  lcd.drawFilledRectangle(2, leftPaddleY, 3, PADDLE_HEIGHT)
  -- Draw right paddle
  lcd.drawFilledRectangle(SCREEN_W - 5, rightPaddleY, 3, PADDLE_HEIGHT)
  -- Draw ball
  lcd.drawFilledRectangle(ballX, ballY, BALL_SIZE, BALL_SIZE)
  -- Draw score
  lcd.drawText(SCREEN_W - 40, 2, "S:" .. score, SMLSIZE)
end

local function run(event)
  handleInput(event)
  updateBall()
  draw()
  return 0
end

return { run = run }
