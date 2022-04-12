-- title:   Floating Circles
-- author:  JoaoPauloVF
-- desc:    a circles animation generated randomly
-- script:  lua
-- input:   keyboard
-- palette: SWEETIE-16 https://github.com/nesbox/TIC-80/wiki/palette#sweetie-16

--Constants and Variables : line 16
--Position Map            : line 31
--Circle Floating Class   : line 58
--Dot Floating Class      : line 125
--Instances Initialization: line 163

math.randomseed(tstamp())

--CONSTANTS AND VARIABLES
SCREEN_W = 240
SCREEN_H = 136

BACKGROUND = 0 --Black

SPACE = 48
ENTER = 50

countCircles = 10
countDots = 100 --Dots amount. Dots appear behind the circles. 

circles = {}
dots = {}

POSITIONS = {} --It keeps all positions on the screen, and if they are occupied. See below.

function initializePositionsMap()
  for i=0, SCREEN_H-1 do
    local xPositions = {}
    for j=0, SCREEN_W-1 do
      --false: not occupied
      --true : occupied
      xPositions[j] = false 
    end
    POSITIONS[i] = xPositions
  end
end

--Check whether still there are free positions.
function positionsIsFull()
  for i=0, #POSITIONS do
    for j=0, #POSITIONS[i] do
      if not(POSITIONS[i][j]) then
        return false
      end
    end
  end
  
  return true
end

--FLOATING CIRCLE CLASS
function FloatingCircle(positionsMap, positionsIsFull, backgroundColor)
  local self = {}
  
  local yRange = #positionsMap
  local xRange = #positionsMap[0]
  
  self.y = math.random(yRange)
  self.x = math.random(xRange)
  
  --Try a different position if the current one is already occupied.
  --If there aren't free position, ignore it.
  while not(positionsIsFull()) and positionsMap[self.y][self.x] do
    self.y = math.random(yRange)
    self.x = math.random(xRange)
  end
  
  self.maxRadius = not(positionsIsFull()) 
    and math.random(10, 40)
    or math.random(6, 10)
  self.radius = 0
  
  --Set the own position as occupied.
  if not(positionsIsFull()) then
    for i=math.max(0, self.y-self.maxRadius*2), math.min(yRange, self.y+self.maxRadius*2) do
      for j=self.x-self.maxRadius*2, self.x+self.maxRadius*2 do
        positionsMap[i][j] = true
      end
    end
  end
  
  self.yDirs = {1, -1}
  self.currY = y
  self.yInterval = math.random(1,6) * self.yDirs[math.random(2)]
  
  self.colorFill = math.random(15)
  while self.colorFill == backgroundColor do self.colorFill = math.random(15) end
  
  self.colorBorder = math.random(15)
  self.borderWeight = self.maxRadius*0.1
  
  self.update = function()
    local cos = self.yInterval * math.cos(time()/800)
    self.currY = self.y + cos
    
    self.radius = self.radius < self.maxRadius
      and self.radius + 2
      or self.radius 
  end
  
  self.render = function()
    circ(
      self.x, self.currY,
      self.radius + self.borderWeight,
      self.colorBorder
    )
  
    circ(
      self.x, self.currY,
      self.radius,
      self.colorFill
    )
  end
  
  return self
end

--FLOATING DOT CLASS
function FloatingDot()
  local self = {}
  
  self.x = math.random(SCREEN_W)
  self.y = math.random(SCREEN_H)
  self.color = math.random(15)
  
  self.render = function()
    pix(self.x, self.y, self.color)
  end
  
  return self
end


function initializeCircles(countCircles)
  local pile = {}
  
  for i=1, countCircles do
    c = FloatingCircle(POSITIONS, positionsIsFull, BACKGROUND) 
    table.insert(pile, c)
  end
  
  return pile
end

function initializeDots(countDots)
  local pile = {}
  
  for i=1, countDots do
    dot = FloatingDot()  
    table.insert(pile, dot)
  end
  
  return pile
end

--instances(from FloatingCircle and FloatingDot) initialization
initializePositionsMap()
circles = initializeCircles(countCircles)
dots = initializeDots(countDots)
function TIC()
  cls(BACKGROUND)
  
  if keyp(SPACE, 0, 120) or keyp(ENTER, 0, 120) then
    initializePositionsMap()
    circles = initializeCircles(countCircles)
    dots    = initializeDots(countDots)
  end
    
  for index, circle in pairs(circles) do
    circle.update()
  end
  
  for index, dot in pairs(dots) do
    dot.render()
  end
  
  for index, circle in pairs(circles) do
    circle.render()
  end
end
