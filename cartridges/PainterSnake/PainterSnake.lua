-- title:  Painter Snake
-- author: JoaoPauloVF
-- desc:   Control a cute snake and paint a gray screen.
-- script: lua
-- input: mouse
-- palette: SWEETIE-16
-- license: MIT
-- version: 0.2
-- github: https://github.com/JoaoPauloVF/My-TIC-Cartridges#readme

--[[
            ----Summary----
            
(search for the term and press down):

--Constants

--Vector function
--subVectors function

--motion functions
	--goTo
	--moveCircle
	--posCirc

--snake code
	--Body function
	--Snake Table

--TIC()
--render renderOVR()
]]--

--Constants
WIDTH = 240
HEIGHT = 136

BG_COLOR = 15
OVR_ADDR = 0x03FF8

----Vector function----
--[[
	This function returns a vector.

	Vectors are util to represent 
	position and velocity.

	If you want to learn more about 
	vectors, I recomend this 
	youtube video: 
	
	https://youtu.be/bKEaK7WNLzM
]]--
function Vector(x, y, xOrigin, yOrigin)
	local self = {}
  
	self.x = x or 1
	self.y = y or 0
  
	local origin = {
		x = xOrigin or 0,
		y = yOrigin or 0
	}
  
  
	self.getDir = function() --In radians
		return math.atan(
			self.y - origin.y,
			self.x - origin.x
		)
	end
	self.setDir = function(value)
		local mag = self.getMag()       
		self.x = mag * math.cos(value)
		self.y = mag * math.sin(value)
	end
  
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

----subVectors function----
--[[
	This function returns a new 
	vector from an operation of 
	other vectors.
]]--

function subVectors(v1, v2)--subVectors function
	return Vector(v1.x-v2.x, v1.y-v2.y)
end

----motion functions----
--[[
	These functions use vectors to 
	create motion.
]]--

----goTo----
--[[
	Move something from an 
	origin point to another 
	destination point.
]]--
function goTo(origin, dest, velVector, speed)--goTo function
	--velVector = subVectors(dest, origin)
	velVector.x = dest.x - origin.x
	velVector.y = dest.y - origin.y

	local gotOnDest = 
		velVector.getMag() 
		<= speed
	if gotOnDest then
		velVector.setMag(0)
	else
		velVector.setMag(speed)
	end
 
 --Go to the destination
	origin.add(velVector)  
end

----moveCircle----
--[[
	It moves something(via the 
	posCirc vector)around 
	a point(the posCenter 
	vector).
]]--
function moveCircle(posCenter, posCirc, radius, angleVel)
	posCirc.x = posCenter.x + radius * math.cos((time()/1000)*angleVel)
	posCirc.y = posCenter.y + radius * math.sin((time()/1000)*angleVel)    
end
----posCirc----
--[[
	It positions a vector(posCirc) on 
	the circumference of a circle 
	with another vector as its center
	(posCenter).
]]--
function posCirc(posCenter, posCirc, radius, angle)
	posCirc.x = posCenter.x + radius * math.cos(angle)
	posCirc.y = posCenter.y + radius * math.sin(angle)
end

----snake code----
--[[
	These last lines before the TIC() 
	make the snake exists.
]]--

----Body function----
--[[
	Returns parts of the snake.
	These parts are :"head", "body" and
	"tail". Each part has its update and 
	render functions.
]]--
function Body(settings)
	local self = {}
	--attributes
	self.type = settings.type
	self.pos = settings.pos
	self.speed = settings.speed   
	self.radius = settings.radius or 8
	self.color = settings.color or {12, 0, 0, 0}--{body, tongue, eyes, tail}
	self.minDist = settings.minDist
	self.palette = settings.palette or {5, 6, 7}
	
	self.vel = Vector(1, 0)
	self.angleVel = 0
	
	self.target = Vector()
  
        
	--update()
	self.update = function() end
 --Get the distante between the current position and the target position.
 local getDist = function()
 	local distVector = subVectors(self.target, self.pos)
  return distVector.getMag()
 end
 
	if self.type == "body" or self.type == "tail" then
		
		self.update = function()   
			self.angleVel = self.vel.getDir()  
			
			if getDist() > self.radius*0.75 then
				goTo(self.pos, self.target, self.vel, self.speed)
			end              
		end
  
		elseif self.type == "head" then
			
			self.update = function()
				self.angleVel = self.vel.getDir()
         
				--When the cursor is out of the 
				--screen, the snake goes to the 
				--center.
				mouseX, mouseY = mouse()
				if mouseX > WIDTH*1.05 or mouseY > HEIGHT*1.05 then
					mouseX = WIDTH*0.5
					mouseY = HEIGHT*0.5
				end
    
    --Choose the target behavior  
				if getDist() <= self.minDist then
					moveCircle(Vector(mouseX, mouseY), self.target, self.minDist, self.speed*2)
				else
					posCirc(Vector(mouseX, mouseY), self.target, self.minDist, self.angleVel)
				end
      
				goTo(self.pos, self.target, self.vel, self.speed)
  	end
  end
  
	--render()
	self.render = function()  end
  
	self.renderBody = function()
		circ(
			self.pos.x, self.pos.y,
			self.radius,
			self.color[1]
		)
	end
	
	if self.type == "head" then
    
		self.renderTongue = function()  
			local posTongue = Vector(
				self.pos.x+(self.radius*1.5)*math.cos(self.angleVel),
				self.pos.y+(self.radius*1.5)*math.sin(self.angleVel)
			)
            
			line(
				self.pos.x, self.pos.y,
				posTongue.x, posTongue.y,
				self.color[2]
			)
			for i=-1,1,2 do
				line(
					posTongue.x, posTongue.y,
					posTongue.x+2*math.cos(self.angleVel+math.pi*i/4),
					posTongue.y+2*math.sin(self.angleVel+math.pi*i/4),
					self.color[2]
				)
			end
		end
    
		self.renderEyes = function()
			for i=-1,1,2 do
				pix(
					self.pos.x+self.radius/2*math.cos(self.angleVel+math.pi*i/3),
					self.pos.y+self.radius/2*math.sin(self.angleVel+math.pi*i/3),
					self.color[3]
				)
			end
		end
		
		self.render = function()
			self.renderTongue()
			self.renderBody()
			self.renderEyes()
		end
  
 elseif self.type == "body" then
	
		self.render = function()  
		 self.renderBody()
		end

 elseif self.type == "tail" then
   
  self.renderTail = function()
  	for r=2,3 do
				local color = self.color[4]
				local posTail = Vector(
					self.pos.x+(self.radius+(3-r)*r)*math.cos(self.angleVel+math.pi),
					self.pos.y+(self.radius+(3-r)*r)*math.sin(self.angleVel+math.pi)
				)
				circ(
					posTail.x, posTail.y,
					r,
					color
				)
			end
		end
    
		self.render = function()    
			self.renderTail()
			self.renderBody()
		end
	end
  
	self.paint = function()
		local c = self.palette[math.random(1, #self.palette)]
    
		if time()%700 < 20 then
			circ(
				self.pos.x, self.pos.y,
				self.radius,
				c
			)
		end
	end
  
  
	return self
end

----Snake Table----
--[[
	Here, a table manages different 
	body parts to form the complete 
	snake.
]]--

--Snake attributes
snake = {}
snakeLenght = 16
snakeWeight = 8 --radius
snakePos = Vector(-8, HEIGHT/2)
snakePalette = {1,2,3,4,5,6,7,8,9,10,11,12}

--Initialize the snake
for i=snakeLenght,1,-1 do
	local type = i==1 and "head" or (i==snakeLenght and "tail" or "body")
	local color = {7-(i%3), 2, 0, 4}--{body, tongue, eyes, tail}
  
	local b = Body({
		pos = Vector(snakePos.x-i*snakeWeight, snakePos.y),
		speed = 1.5, 
		type = type, 
		minDist = snakeLenght*(snakeWeight/2),
		color = color,
		radius = snakeWeight,
		palette = snakePalette
	})
  
	table.insert(snake, b)
end


cls(BG_COLOR)
function TIC()
 --Update the target of each body part 
	for k, b in pairs(snake) do
		if b.type == "body" or b.type == "tail" then
			b.target = snake[k+1].pos
		end
	end
	--Move all the body parts
	for k, b in pairs(snake) do
		b.update()
	end
 
 --The snake paints the background layer.
	vbank(0)
	for k, b in pairs(snake) do
		b.paint()
	end
 
 --Render over layer
	renderOVR()
end

----renderOVR()----
--[[
	It renders the snake on the
	over layer.
]]--
function renderOVR()
	vbank(1)
	--Set ovr transparence
	poke(OVR_ADDR, BG_COLOR)
	
	cls(BG_COLOR)
	--Render the snake
	for k, b in pairs(snake) do
		b.render()
	end
end
