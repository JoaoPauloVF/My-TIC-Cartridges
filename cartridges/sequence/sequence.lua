-- title:  getSequence Function
-- author: JoaoPauloVF
-- desc:   a function that creates numeric sequences
-- script: lua
-- input: keyboard
--[[
SUMMARY(ctrl+f and search for the chapter)

 DESCRIPTION....................:-1-
 getSequence                    :-2-
 PARAMETERS.....................:-3-
 HOW TO USE                     :-4-
 NOTES..........................:-5-
 FUNCTION CODE                  :-6-
 DEMO CODE......................:-7-

]]--

--Constants
WIDTH = 240
HEIGHT = 136

UP = 0
DOWN = 1
LEFT = 2
RIGHT = 3
Z = 4

background = 15
lineColor = 12

--[[
           -1--DESCRIPTION----
    
    This function returns a numeric 
  array based on a math function.           
           
           -2--getSequence----
getSequence (mathFunc, [lenght=1]) --> numeric array 

getSequence (mathFunc, min, max, [step=1]) --> numeric array
           
           -3--PARAMETERS----

mathFunc: 

       A function that serves as a 
       math function. 
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
       
       The number of input values to 
       the math function, that starts 
       from one. 
       For example, in the following 
       code:
        
         f = function(num)
           return num*2
         end
          
         list = getSequence(f, 5)
       
       the variable list will get 
       {2, 4, 6, 8, 10} from the 
       function.

min, max, step: 
            
       You also can set the starting
       (min), ending(max), and the 
       increment(step) of the 
       sequence. 
       For instance, altering the 
       before code:
           
         f = function(num)
           return num*2
         end
          
         list = getSequence(f, 4, 0, -1)
         
       list will have {8, 6, 4, 2, 0}
       as value.
          
           -4--HOW TO USE----
    
    You can copy the following 
  function to your code and use it.
  You can see the demo code, after 
  the function code, for some 
  insights too.

             -5--NOTES----
  
  *The function doesn't have errors 
  handling. Then, things like zero 
  division, square root of negative 
  numbers, and incorrect recursion 
  will crash your program.
  Keep an eye on how you write the 
  math function.
  
  *An update idea is to create another
  function that returns a matrix of 
  values instead of an array only.

]]--
        --6--- FUNCTION CODE
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

         --7--- DEMO CODE

--Some math functions
function baseTwo(num)
  return 2^num
end

function fatorial(num)
  if num <=1 then
    return 1
  end
  
  return num*fatorial(num-1)
end

function fibonacci(num)
  if num <=0 then
    return 0
  end
  if num == 1 then
    return 1
  end
  
  return fibonacci(num-1)+fibonacci(num-2)
end

--list of other math functions on demo
x25 = WIDTH*0.25
funcs = {
  {label="f(num) = (num)", func=function(num)return num end, maxSc=14, minSc=6, minNum=-x25, maxNum=x25},
  {label="f(num) = (num*num)", func=function(num)return num*num end, maxSc=8, minSc=1, minNum=-x25, maxNum=x25},
  {label="f(num) = (num^3)", func=function(num)return num^3 end, maxSc=8, minSc=1, minNum=-x25, maxNum=x25},
  {label="f(num) = sqrt(num)", func=function(num)return math.sqrt(num)end, maxSc=11, minSc=7, minNum=0, maxNum=x25*2},
  {label="f(num) = (1/num)", func=function(num)return 1/num end, maxSc=14, minSc=7, minNum=1, maxNum=x25*2+1},
  {label="f(num) = (num%2)", func=function(num)return num%2 end, maxSc=14, minSc=7, minNum=-x25, maxNum=x25},
  {label="f(num) = (sin(num/8))", func=function(num)return math.sin(num/8) end, maxSc=14, minSc=7, minNum=-x25, maxNum=x25},
  {label="f(num) = (cos(num/8))", func=function(num)return math.cos(num/8) end, maxSc=14, minSc=7, minNum=-x25, maxNum=x25},
  {label="f(num) = (tan(num/8))", func=function(num)return math.tan(num/8) end, maxSc=14, minSc=7, minNum=-x25, maxNum=x25},
  {label="f(num) = (sin(num/8)+sin(num/4))", func=function(num)return math.sin(num/8)+math.sin(num/4) end, maxSc=14, minSc=7, minNum=-x25, maxNum=x25},
  {label="f(num) = 1", func=function(num)return 1 end, maxSc=14, minSc=7, minNum=-x25, maxNum=x25},
  {label="f(num) = random()", func=function(num)return math.random() end, maxSc=14, minSc=7, minNum=-x25, maxNum=x25},
  {label="f(num) = (random()+random())", func=function(num)return math.random()+math.random() end, maxSc=14, minSc=7, minNum=-x25, maxNum=x25},
  {label="f(num) = (f(num-1)+f(num-2))", func=fibonacci, maxSc=14, minSc=7, minNum=0, maxNum=10},
  {label="f(num) = (num*f(num-1))", func=fatorial, maxSc=7, minSc=1, minNum=0, maxNum=8}
}
currFunc = 1
lastFunc = nil

--Scales sequence
scales = getSequence(baseTwo, -7, 7, 1)
currScale = 8

--tutorial variables
showTexts = true
tutTexts = {
  "LEFT/RIGHT: alter the function",
  "UP/DOWN: alter scale",
  "Z: hide or show texts"
}
tutX = 0
tutY = HEIGHT*0.5
tutMargin = 10
tutW = WIDTH*0.72
tutH = HEIGHT*0.38

function TIC()
  
  --Check what is the current function on screen
  if btnp(RIGHT, 0, 10) then
    currFunc = math.min(#funcs, currFunc+1)
  end
  if btnp(LEFT, 0, 10) then
    currFunc = math.max(1, currFunc-1) 
  end
  --Check the current scale
  if btnp(UP, 0, 10) or currFunc~=lastFunc then
    currScale = math.min(funcs[currFunc].maxSc, currScale+1)
  end
  if btnp(DOWN, 0, 10) or currFunc~=lastFunc then
    currScale = math.max(funcs[currFunc].minSc, currScale-1) 
  end
  --Check if the texts can appear or not
  if btnp(Z, 0, 10) then
    showTexts = not(showTexts)
  end
  
  --Update the current sequence
  seq = lastFunc~=currFunc 
   and getSequence(funcs[currFunc].func, funcs[currFunc].minNum, funcs[currFunc].maxNum)
   or seq
  
  lastFunc = currFunc
  
  --Draw sequence graphic
  cls(background)
  for index, num in pairs(seq) do
    local x = (index-1)*(WIDTH/(#seq-1))
    local y = HEIGHT/2
    local numScaled = num*scales[currScale]
          
    if num ~= 0 then 
      line(
        x, y,
        x, y-numScaled,
        lineColor
      )
    end
  end
  
  if showTexts then
    --Draw function Label
    margin = 8
    rectH = HEIGHT*0.2
    rectW = WIDTH*0.8
    rect(
      margin/2, margin/2,
      rectW, rectH,
      0
    )
    text = funcs[currFunc].label.."*"..tostring(scales[currScale])
    textH = 6
    print(
      text,
      margin, (margin+rectH)/2-textH/2,
      12
    )

    --Draw tutorial
    rect(
      tutMargin/2, tutY+tutMargin/2,
      tutW, tutH,
      0
    )
    
    for i=1, 3 do 
      local text = tutTexts[i]
      print(
        text,
        tutX+tutMargin, tutY+tutMargin*i*(tutH*0.03)-textH/2,
        12
      )
    end
  end
end
