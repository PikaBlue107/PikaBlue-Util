local RIGHT = 1
local FORWARD = 2
local LEFT = 3
local BACK = 4
local UP = 5
local DOWN = 6

-- TODO what happens if these are local?
if not travel_initialized then
  travel_dir = FORWARD
  travel_disp = vector.new(0,0,0)
  travel_initialized = true
end

local DIR_STRINGS = {
  [RIGHT] = "Right",
  [FORWARD] = "Forward",
  [LEFT] = "Left",
  [BACK] = "Back",
  [UP] = "Up",
  [DOWN] = "Down"
}

--Local utility functions

local function bound(arg)
  while arg < 1 do arg = arg + 4 end
  while arg > 4 do arg = arg - 4 end
  return arg
end

local function matchDir(desired, strict)
  strict = strict or false
  turns = bound(desired - travel_dir)
  if turns == 3 then turnRight()
  elseif turns == 2 then
    if strict then turnRight(2) else return false end
  elseif turns == 1 then turnLeft()
  end
  return true
end

local function move(num)
  if num >= 0 then
    func = turtle.forward
  else
    num = -num
    func = turtle.back
  end
  traveled=0
  for i=1,num do    --TODO add fuel checking to movement, maybe add checking?
    if func() then
      traveled = traveled+1
    end
  end
  return traveled
end

local function vert(direction, num)
  traveled=0;
  if direction == UP then
    func = turtle.up
  elseif direction == DOWN then
    func = turtle.down
  end

  for i=1,num do
    -- try to move, if successful, add 1 to return value
    if func() then traveled = traveled + 1 end
  end

  return traveled
end

local function travel(direction, num)
  num = num or 1
  forward = matchDir(direction)
  if not forward then num = -num end
  return move(num)
end

-- API functions

function getDir()
  return travel_dir
end

function getDirStr()
  return DIR_STRINGS[travel_dir]
end

function printDir()
  print(DIR_STRINGS[travel_dir])
end

function getDisp()
  return travel_disp
end

function printDisp()
  for label,coord in pairs(travel_disp) do
    print(label..": "..coord)
  end
end

function turnRight (num)
  num = num or 1
  for i=1,num do
    turtle.turnRight()
    travel_dir = bound(travel_dir - 1)
  end
end

function turnLeft (num)
  num = num or 1
  for i=1,num do
    turtle.turnLeft()
    travel_dir = bound(travel_dir + 1)
  end
end

function forward(num)
  traveled=travel(FORWARD, num)
  travel_disp.z = travel_disp.z + traveled
  return traveled
end

function back(num)
  traveled=travel(BACK, num)
  travel_disp.z = travel_disp.z - traveled
  return traveled
end

function right(num)
  traveled=travel(RIGHT, num)
  travel_disp.x = travel_disp.x + traveled
  return traveled
end

function left(num)
  traveled=travel(LEFT, num)
  travel_disp.x = travel_disp.x - traveled
  return traveled
end

function up(num)
  num = num or 1
  traveled=vert(UP, num)
  travel_disp.y = travel_disp.y + traveled
  return traveled
end

function down(num)
  num = num or 1
  traveled=vert(DOWN, num)
  travel_disp.y = travel_disp.y - traveled
  return traveled
end

arg1, arg2 = ...

--if arg1 ~= nil then
--  travel[arg1](arg2)
--end

local functions = {
  ["printDir"]=printDir,
  ["printDisp"]=printDisp,
  ["turnRight"]=turnRight,
  ["turnLeft"]=turnLeft,
  ["forward"]=forward,
  ["back"]=back,
  ["right"]=right,
  ["left"]=left,
  ["up"]=up,
  ["down"]=down
}

local func_name = functions[arg1]
local count = tonumber(arg2)

if func_name ~= nil then
  func_name(count) 
elseif arg1 == "face" then

  if arg2 == "forward" then arg2 = FORWARD
  elseif arg2 == "right" then arg2 = RIGHT
  elseif arg2 == "back" then arg2 = BACK
  elseif arg2 == "left" then arg2 = LEFT
  else arg2 = nil
  end
  
  if arg2 ~= nil then
    matchDir(arg2, true)
  end
end