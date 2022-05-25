-- title:   getSequence Function
-- author:  JoaoPauloVF
-- desc:    a function that creates numeric sequences
-- script:  lua
-- input:   mouse, keyboard
-- version: 0.2
-- license: MIT
-- github:  https://github.com/JoaoPauloVF/My-TIC-Cartridges#readme
--[[

           ----Summary----

(ctrl+f and search for the chapter)

	Description....................:-1-
	getSequence                    :-2-
	Paraments......................:-3-
	How To Use                     :-4-
 
 Constants
 Function Code..................:-5-
 Demo Code                      :-6-
 Math Functions
 Graph Code
 	Scales Sequence
  Functions List
  Current Sequence
  renderGraph()
 Texts Code
 	printWithRect()
  printTexts()
  

]]--

--[[
           -1--Description----
    
	This function returns a numeric array
 based on a math function.           
           
           -2--getSequence----
	
	getSequence (mathFunc, [lenght=1]) --> numeric array 

	getSequence (mathFunc, min, max, [step=1]) --> numeric array
           
           -3--Paraments----

	mathFunc: 

	A function that serves as a math 
	function. 
	It must get and return a 
	number.
          
	For example, these are valid 
	functions:
          
		function f(num)
			return num+1
		end
          
		function f(num)
			return num*3 - 1
		end
          
		function f(num)
			return 8
		end

	lenght: 
       
		The number of input values to the 
		math function, that starts from one. 
		For example, in the following 
		code:
        
			f = function(num)
				return num*2
			end
          
			list = getSequence(f, 5)
       
		the variable list will get 
		{2, 4, 6, 8, 10} from the function.

	min, max, step: 
            
		You also can set the starting(min), 
		ending(max), and the increment(step)
	 of the sequence. 
		For instance, altering the 
		before code:
           
			f = function(num)
				return num*2
			end
          
			list = getSequence(f, 4, 0, -1)
         
		list will have {8, 6, 4, 2, 0} 
		as value.
          
           -4--How To Use----
    
	You can copy the function, bellow the 
	following constants, to your code and 
	use it.
	
	You can see the demo code, after the 
	function code, for some insights too.
]]--
----Constants----
WIDTH = 240
HEIGHT = 136

x50 = WIDTH*0.5
y50 = HEIGHT*0.5

FONT_H = 6

--Buttons
UP = 0
DOWN = 1
LEFT = 2
RIGHT = 3
Z = 4

--Colors
background = 15
xColor = 6
yColor = 10
pointColor = 12

tutTexts = {
  "LEFT/RIGHT: alter the function",
  "UP/DOWN: alter scale",
  "Z: hide or show texts"
}

--5--- Function Code
function getSequence(mathFunc, min, max, step)
  local seq = {}
  step = step or 1
  min = min or 1
  
  if not(max) then
    min, max = max, min
    min = 1
  end
  
  for num=min, max, step do
    table.insert(seq, mathFunc(num))
  end
  
  return seq
end

--6--Demo Code----
--[[
	Here, it stays the demo code. 
	
	It consists in showing the texts and 
	the graph of some math functions.
]]--

----Math Functions----
--[[
	The math functions in the demo.
	
	They get and returns a number.
	If the input number lets to an error,
 like zero division, 
 the function returns nil.
]]--
function linear(num)
	return num
end

function square(num)
	return num*num 
end

function cube(num)
	return num^3
end

function squareRoot(num)
	if num < 0 then
		return nil
	end
	return math.sqrt(num)
end

function logarithm(num)
	if num < 0 then
		return nil
	end
	return math.log(num)
end

function inverse(num)
	if num == 0 then
		return nil
	end
	return 1/num 
end

function module2(num)
	return num%2 
end

function sine(num)
	return math.sin(num/8) 
end

function arcSine(num)
	if (num/8) > 1 and (num/8) < -1 then
		return nil
	end
	return math.asin(num/8) 
end

function sineSum(num)
	return math.sin(num/8) + math.sin(num/4)
end

function cosine(num)
	return math.cos(num/8) 
end

function tangent(num)
	return math.tan(num/8)
end

function randomSum(num)
	return math.random()+math.random()
end

function baseTwo(num)
	return 2^num
end

----Graph Code----

----Scales Sequence----
--[[
	It holds the different scales applied
 to the graph.
]]--
scales = getSequence(baseTwo, -8, 7, 1) --#scales == 15
currScale = 8
--Update the scale
function updateScale()
	if btnp(UP, 0, 10) or currFunc~=lastFunc then
		currScale = math.min(funcs[currFunc].maxSc, currScale+1)
	end
	if btnp(DOWN, 0, 10) or currFunc~=lastFunc then
		currScale = math.max(funcs[currFunc].minSc, currScale-1) 
	end
end
----Functions List----
--[[
	It lists info to make the current 
	graph on the screen(label, starting, 
	ending, math function, etc.).
]]--
funcs = {
  {
  	label = "f(num) = (num)", 
   func = linear, 
   maxSc = #scales-3, minSc = #scales//2 - 1, 
   minNum = -x50, maxNum = x50
  },
  {
  	label = "f(num) = (num*num)", 
   func = square, 
   maxSc = #scales//2, minSc = 1, 
   minNum = -x50, maxNum = x50
  },
  {
  	label = "f(num) = (num^3)", 
   func = cube, 
   maxSc = #scales//2, minSc = 1, 
   minNum = -x50, maxNum = x50
  },
  {
  	label = "f(num) = 2^num", 
   func = baseTwo, 
   maxSc = #scales//2, minSc = 1, 
   minNum = 0, maxNum = x50*2
  },
  {
  	label = "f(num) = sqrt(num)", 
   func = squareRoot, 
   maxSc = #scales-4, minSc = #scales//2, 
   minNum = 0, maxNum = x50*2
  },
  {
  	label = "f(num) = log(num)", 
   func = logarithm, 
   maxSc = #scales-3, minSc = #scales//2, 
   minNum = 1, maxNum = x50*2+1
  },
  {
  	label = "f(num) = (1/num)", 
   func = inverse,
   maxSc = #scales, minSc = #scales//2, 
   minNum = -x50, maxNum = x50
  },
  {
  	label = "f(num) = (num%2)", 
   func = module2, 
   maxSc = #scales-1, minSc = #scales//2, 
   minNum = -x50, maxNum = x50
  },
  {
  	label = "f(num) = (sin(num/8))", 
   func = sine, 
   maxSc = #scales, minSc = #scales//2, 
   minNum = -x50, maxNum = x50
  },
  {
  	label = "f(num) = (cos(num/8))", 
   func = cosine, 
   maxSc = #scales, minSc = #scales//2, 
   minNum = -x50, maxNum = x50
  },
  {
  	label = "f(num) = (tan(num/8))", 
   func = tangent, 
   maxSc = #scales, minSc = #scales//2, 
   minNum = -x50, maxNum = x50
  },
  {
  	label = "f(num) = (asin(num/8))", 
   func = arcSine, 
   maxSc = #scales, minSc = #scales//2, 
   minNum = -x50, maxNum = x50
  },
  {
  	label = "f(num) = (sin(num/8)+sin(num/4))", 
   func = sineSum, 
   maxSc = #scales, minSc = #scales//2, 
   minNum = -x50, maxNum = x50
  },
  {
  	label = "f(num) = 1", 
   func = function(num)return 1 end, 
   maxSc = #scales-1, minSc = #scales//2, 
   minNum = -x50, maxNum = x50
  },
  {
  	label = "f(num) = random()", 
   func = function(num)return math.random() end, 
   maxSc = #scales, minSc=#scales//2, 
   minNum = -x50, maxNum = x50
  },
  {
  	label="f(num) = (random()+random())", 
   func=randomSum, 
   maxSc=#scales, minSc=#scales//2, 
   minNum = -x50, maxNum = x50
  }
}

currFunc = 1
lastFunc = nil
function updateCurrFunc()
	if btnp(RIGHT, 0, 10) then
		currFunc = math.min(#funcs, currFunc+1)
	end
	if btnp(LEFT, 0, 10) then
		currFunc = math.max(1, currFunc-1) 
	end
end

----Current Sequence----
--[[
	It is created from the info of the
 previous list.
 
 The numbers of this sequence form 
 the graph points.
]]--
currSeq = nil
function updateSeq()
	currSeq = lastFunc~=currFunc 
	and getSequence(funcs[currFunc].func, funcs[currFunc].minNum, funcs[currFunc].maxNum) 
	or currSeq
end
updateSeq()

----renderGraph()----
--[[
	It draws the horizontal and vertical 
	axes and the sequence points.
]]--
function renderGraph(seq)
	local margin = 2
	
	--Render horizontal line, subtitle, and numbers
	line(
		0, y50,
		WIDTH, y50,
		xColor
	)
	print(
		"num", 
		margin, y50 - FONT_H, 
		xColor
	)
	for i=0, 2 do
		local x = i*x50+margin
		if i == 2 then
			x = x - 18
		end
		
		local numValue = (i*x50)+funcs[currFunc].minNum
		print(
			string.format("%i", numValue),
			x, y50 + FONT_H/2,
			xColor, 
			false, 1,
			true
		)
	end
	
	--Render vertical line, subtitle, and numbers
	line(
		x50, 0,
		x50, HEIGHT,
		yColor
	)
	print(
		"f(num)", 
		x50 + margin, margin, 
		yColor
	)
	for i=0, 2 do
		local y = (2-i)*y50
		if i == 0 then
			y = y - (FONT_H+margin)
		end
		
		print(
			(i-1)*HEIGHT//2,
			x50-12, y+margin,
			yColor, 
			false, 1,
			true
		)
	end
	
	--Render graph points
	for index, num in pairs(seq) do
		local x = (index-1)
		local y = HEIGHT/2
		
		if num then --If num is equal nil, f(num) could allow a crash.
			local numScaled = num*scales[currScale]
			
			pix(
				x, y-numScaled,
				pointColor
			)
			end
	end
end

---Texts Code----

----showTexts----
--[[
	It shows/hides the text when 
	pressing "Z".
]]--
showTexts = true
function updateShowText()
	if btnp(Z, 0, 10) then
		showTexts = not(showTexts)
	end
end

----printWithRect()----
--[[
	This function highlights texts by 
	printing them in a black rectangle.
	
	The text can be a string or a list of
 strings(to multiple-lines texts).
]]--
function printWithRect(text, x, y)
	--Get the text width
	local biggerW = nil
	if type(text) == "table" then
		biggerW = print(text[1], 0, -FONT_H)
		for i=2, #text do
			local w = print(text[i], 0, -FONT_H)
			biggerW = w > biggerW and w or biggerW
		end
	end
	local textW = biggerW or print(text, 0, -FONT_H)
	
	--Internal rectangle margin
	local margin = 3
	
	local rectW = textW + 2*margin
	local rectH = type(text)=="table" and 1.5*(#text*FONT_H+(#text+1)*margin)  or FONT_H + 2*margin
	--Render the rectangle
	rect(
		x, y,
		rectW, rectH,
		0
	)
	--Print the text
	if type(text)=="table" then
		for i=1, #text do
			print(
				text[i],
				x+margin, y+1.5*(margin*i+FONT_H*(i-1)),
				12
			)
		end
	else
		print(
			text,
			x+margin, y+margin,
			12
		)
	end
end
----printTexts()----
--It prints all the texts.
function printTexts()
	if showTexts then
		--Function Label
		text = funcs[currFunc].label.."*"..tostring(scales[currScale])
		printWithRect(text, WIDTH*0.015, HEIGHT*0.03)
		
		--Tutorial
		printWithRect(tutTexts, WIDTH*0.015, HEIGHT*0.6)
	end
end

----TIC() Function----
function TIC()
	updateCurrFunc()
	updateScale()
	updateSeq()
	updateShowText()
	
	lastFunc = currFunc
	
	cls(background)
	renderGraph(currSeq)
	printTexts()
end
