-- title:  Magnetic Pointer
-- author: JoaoPauloVF
-- desc:   An interactive demo about repulsion and attraction forces
-- script: lua
-- input: mouse, keyboard
-- palette: SWEETIE-16 https://github.com/nesbox/TIC-80/wiki/palette#sweetie-16

--[[
SUMMARY(search for the term and press down):

--Constants

--Vector Function
--Vectors Operations Functions

--forceField function
--Particle function

--system Table
--subSystem Table
--Particle System Functions

--Initializations

--function TIC()
]]--

--Constants
WIDTH = 240
HEIGHT = 136

UP = 0
DOWN = 1
Z = 4

background = 15
subSystemLimit = 400

----Vector Function----
--[[
  Returns a Vector object.
  Vectors can represent positions, 
  velocities, and accelerations.
  
  You can see this on the Particle 
  function.
]]--
function Vector(x, y, xOrigin, yOrigin)
  local self = {}
  
  self.x = x or 0
  self.y = y or 0
  
  local origin = {
    x = xOrigin or 0,
    y = yOrigin or 0
  }
  
    
  self.getMag = function()
    return math.sqrt(
      (self.x-origin.x)^2 
      + (self.y-origin.y)^2
    )
  end
  
  self.normalize = function()
    local mag = self.getMag()
    if mag == 0 then mag = 1 end
    self.mult(1/mag)
  end
  
  self.setMag = function(value)
    self.normalize()
    
    self.mult(value)
  end
  
  self.add = function(vector)
    self.x = self.x + vector.x
    self.y = self.y + vector.y
  end
  
  self.mult = function(scalar)
    self.x = self.x * scalar
    self.y = self.y * scalar
  end
  
  self.limit = function(scalar)
    self.setMag(math.min(scalar, self.getMag(origin)))
  end
  
  return self
end
----Vectors Operations Functions----
--[[
  These functions return a new vector 
  from other vectors.
]]--
function sumVectors(...)
  local sumX = 0
  local sumY = 0
  for k, vector in ipairs{...} do
    sumX = sumX + vector.x
    sumY = sumY + vector.y
  end
    
  return Vector(sumX, sumY)
end

function subVectors(v1, v2)
  return Vector(v1.x-v2.x, v1.y-v2.y)
end

function multVector(v, value)
  return Vector(v.x*value, v.y*value)
end

function divVector(v, value)
  return Vector(v.x/value, v.y/value)
end

----forceField function----
--[[
  Returns a force field object.
  
  This force field is controlled 
  by the mouse: Its position depends 
  on the mouse pointer and its state
  (if it attracts or repulses) depends
  on which mouse button is pressed.
]]--
function forceField(radius, forceMag, palette)
  local self = {}
  
  self.pos = Vector(mouse())
  self.radius = radius or 10
  self.forceMag = forceMag or 1
  
  self.palette = palette or {none=13, attraction=2, repulsion=10}
  self.color = self.palette["none"]
  
  self.state = "none"
  local forceR = 0
  
  local minRadius, maxRadius = 1, HEIGHT*0.5
  
  self.update = function()
    local mx, my, left, middle, right, scrollX, scrollY = mouse()
    
    self.pos.x = mx
    self.pos.y = my
    
    --Update radius
    self.radius = math.min(maxRadius, math.max(minRadius, self.radius + scrollY))
    
    --Update field state
    if left then
      self.state = "attraction"
    elseif right then
      self.state = "repulsion"
    else
      self.state = "none"
    end
    
    --Update the circle radius used for the force animation.
    if self.state == "none" then
      forceR = 0
    elseif self.state == "attraction" then
      forceR = forceR - self.forceMag
      if forceR <= 0 then
        forceR = self.radius
      end
    else--repulsion
      forceR = forceR + self.forceMag
      if forceR >= self.radius then
        forceR = 0
      end
    end
    
    self.color = self.palette[self.state]
  end
  
  self.render = function()
    --render force
    circb(
      self.pos.x, self.pos.y,
      forceR,
      self.color
    )
    --render field border
    circb(
      self.pos.x, self.pos.y,
      self.radius,
      self.color
    )
  end
  return self
end

----Particle function----
--[[
  Creates a particle. Particles are 
  the "balls" and the "dust" that 
  you interact to.
  
  They react to the force field and 
  the screen edges.
]]--
function Particle(settings)
  local self = {}
  
  self.life = settings.life
  
  self.pos = settings.pos or Vector()
  self.radius = settings.radius or 4
  self.mass = settings.mass or 4
  self.maxSpeed = settings.maxSpeed or 2
  self.color = settings.color or 12
  self.borderColor = settings.borderColor or 12
  self.forceField = settings.forceField
  
  self.vel = Vector()
  self.acc = Vector()
  
  local fieldF = Vector()
  local friction = Vector()
  local frictionC = 0.02
  
  local applyForces = function(...)
    local fList = {}
    for index, force in ipairs{...} do
      fList[index] = divVector(force, self.mass)
    end
    
    self.acc = sumVectors(table.unpack(fList))
  end
  
  local interactToField = function()
    local attVector = subVectors(self.forceField.pos, self.pos)
    local dist = attVector.getMag()
    
    attVector.setMag(self.forceField.forceMag)
    
    if dist <= self.forceField.radius + self.radius then
		    if self.forceField.state == "none" then
		      fieldF.setMag(0)
		    elseif self.forceField.state == "attraction" then
		      fieldF = multVector(attVector, 1)
		    else--repulsion
		      fieldF = multVector(attVector, -1)
		    end
				end
  end
  
  local interactToEdges = function()
    local minX, minY = self.radius, self.radius
    local maxX, maxY = WIDTH - self.radius, HEIGHT - self.radius
    
    local impactLoss = self.mass * frictionC
    
    if self.pos.x < minX or self.pos.x > maxX then
      self.pos.x = math.min(maxX, math.max(minX, self.pos.x))
      
      self.vel.x = -self.vel.x
      fieldF.x = -fieldF.x
      
      self.vel.mult(1-impactLoss)
      fieldF.mult(1-impactLoss)
    end
    if self.pos.y < minY or self.pos.y > maxY then
      self.pos.y = math.min(maxY, math.max(minY, self.pos.y))
      
      self.vel.y = -self.vel.y
      fieldF.y = -fieldF.y
      
      self.vel.mult(1-impactLoss)
      fieldF.mult(1-impactLoss)
    end
  end
  
  self.update = function()
    if self.life then
      self.life = self.life-1
    end
    
    interactToField()
    interactToEdges()
    
    friction = multVector(self.vel, -1*frictionC*self.mass)
    
    applyForces(fieldF, friction)
    
    self.vel.add(self.acc)
    self.vel.limit(self.maxSpeed)
    self.pos.add(self.vel)
  end
  
  self.render = function()
    circ(
      self.pos.x, self.pos.y,
      self.radius+1,
      self.borderColor
    )
    circ(
      self.pos.x, self.pos.y,
      self.radius,
      self.color
    )
  end
  
  return self
end

----system Table----
--[[
  This table holds all the balls
  (the big particles).
]]--
system = {}

----subSystem Table----
--[[
  This table holds all the dust particles
  (the small ones).
]]--
subSystem = {}

----Particle System Functions----
--[[
  These functions manage the update 
  and render of all the particles.
]]--
function newSystem(settings)
    local system = {}
		
    local width = settings.width or 2
    local height = settings.height or 2
    local palette = settings.palette
    local maxSpeed = settings.maxSpeed
    local borderColor = settings.borderColor
		
    local firstColor = math.random(0,3)
	for i=1, width do
	  for j=1, height do
        local x = i*(WIDTH/(width+1))
        local y = j*(HEIGHT/(height+1))
						
        local colorIndex = ((i+j+firstColor)%(#palette))+1
        local color = palette[colorIndex]
		    
        local mass = math.random(2, 4)
        local radius = 2*(((i*j)%2)+1)
		    
		local p = Particle({
		  pos = Vector(x, y), 
		  radius = radius, 
		  mass = mass, 
		  maxSpeed = maxSpeed, 
		  color = color, 
		  borderColor = colorBorder, 
		  forceField = mouseField
		})
		    
        table.insert(system, p)
      end
    end
		
    return system
end

function updateSystem(system, subSystem, subSystemLimit)
  --Update system table
  for _, p in pairs(system) do
    insertSubParticle(subSystem, subSystemLimit, p)
    p.update()
  end
  
  --Update subSystem table
  for _, subP in pairs(subSystem) do
    subP.update()
  end
  
  cleanSubSystem(subSystem)
end

function renderSystem(system, subSystem)
  for _, subP in pairs(subSystem) do
    subP.render()
  end
  for _, p in pairs(system) do
    p.render()
  end
end
--subSystem functions
function insertSubParticle(subSystem, subSystemLimit, p)
  local vel = p.vel.getMag()
  if #subSystem < subSystemLimit and vel > 0 and time()%(3000/vel) < 10 then
    local life = math.random(180, 360)
    
    local subP = Particle({
      pos = multVector(p.pos, 1), 
      radius = 0, 
      mass = 0.1, 
      maxSpeed = p.maxSpeed*2, 
      borderColor = p.color, 
      forceField = mouseField,
      life = life
    })
    
    table.insert(subSystem, subP)
  end
end
function cleanSubSystem(subSystem)
  for index, subP in pairs(subSystem) do
    if subP.life < 0 then
      table.remove(subSystem, index)
    end
  end
end


----Initializations----

--forceField initialization
mouseForceMag = 0.2
maxForceMag = 1
minForceMag = 0.1
mouseField = forceField(20, mouseForceMag)

--system variables
systemW = 17
systemH = 9
palette = {3, 5, 9, 6, 4, 10, 7, 11}

--system initialization
system = newSystem({
  width = systemW,
  height = systemH,
  palette = palette,
  maxSpeed = 4,
  borderColor = 12
})


function TIC()
  --Check reset
  if btnp(Z, 0, 30) then
    system = newSystem({
      width = systemW,
      height = systemH,
      palette = palette,
      maxSpeed = 4,
      borderColor = 12
    })
    
    subSystem = {}
  end
  --Update force magnitude
  if btnp(UP, 0, 10) then
    mouseForceMag = math.min(maxForceMag, mouseForceMag+0.1)
  end
  if btnp(DOWN, 0, 10) then
    mouseForceMag = math.max(minForceMag, mouseForceMag-0.1)
  end
  mouseField.forceMag = mouseForceMag
  
  
  mouseField.update()
  updateSystem(system, subSystem, subSystemLimit)
  
  cls(background)
  renderSystem(system, subSystem)
  mouseField.render()
end
