-- title:  Print Alignment Function
-- author: JoaoPauloVF
-- desc:   It's like the default print function, but with horizontal and vertical alignment params.
-- script: lua
-- palette: SWEETIE-16 https://github.com/nesbox/TIC-80/wiki/palette#sweetie-16

-- Function description: line 38
-- Function code: line 105 to 122 

--Variables to show the function calls examples in the TIC(). It is not essential to use the function.
SCREEN_W = 240
SCREEN_H = 136

YELLOW = 4
LIGHT_GREEN = 5
LIGHT_GRAY = 13
DARK_GRAY = 15

COLOR_TEXT = LIGHT_GRAY

x1  = SCREEN_W * 0.01
x10 = SCREEN_W * 0.10
x25 = SCREEN_W * 0.25

y1  = SCREEN_H * 0.01
y10 = SCREEN_H * 0.10
y25 = SCREEN_H * 0.25

POS_Y = y10 * 8 

alignTable = {
  ["right"] = {posX=x1*5, alignY="bottom"}, 
  ["center"] = {posX=x25*2, alignY="middle"}, 
  ["left"] = {posX=x10*9 + x1*5, alignY="top"}
}

--[[
           ----DESCRIPTION----
           
This function prints a text on the
screen and allows horizontal and
vertical alignment according to its 
position.
           
           
           -----printAlign----

printAlign text [x=0 y=0] [alignX="right"] [alignY="bottom"] [color=15] [fixed=false] [scale=1] [smallfont=false]

           
           -----PARAMETERS----

text: The content to be printed on the
      screen.

x, y: Text coordinates. The alignment 
      is based on these values.

alignX: Text alignment on X-axis
        (this is the horizontal 
        alignment):
 
        "right" : the text stay totally
                  on the right of x
        "center": the text stay center
                  of x
        "left"  : the text stay totally
                  on the left of x 

alignY: Text alignment on Y-axis
        (this is the vertical 
        alignment): 
 
        "bottom": the text stay totally
                  under y
        "middle": the text stay center
                  of y
        "top"   : the text stay totally 
                  above y 

color, fixed, scale, smallFont:
 
        It is the same as the default 
        print.


           ----HOW TO USE----

You can copy and paste the function 
below to your code and use it as 
described above.

             ----NOTES----
* This documentation was inspired by
the wiki section to the print function.
Consider looking at it: 

https://github.com/nesbox/TIC-80/wiki/print

* I made the function only to the 
default font. Maybe it does not works 
well for custom fonts
(anyway, that is an upgrade idea). 
]]--
local function printAlign(text, x, y, alignX, alignY, color, fixed, scale, smallFont)
  local x = x or 0
  local y = y or 0
  local alignX = alignX or "right"
  local alignY = alignY or "bottom"
  local color = color or 15
  local fixed = fixed or false
  local scale = scale or 1
  local smallFont = smallFont or false
  
  local font_h = 6 * scale
  local font_w = print(text, 0, -font_h*scale, color, fixed, scale, smallFont)
  
  x = alignX=="right" and x or alignX=="center" and x - font_w//2 or alignX=="left" and x - font_w + 1*scale or x --if alignX is not any of the accepted values, x gets the default value from "right".
  y = alignY=="bottom" and y or alignY=="middle" and y - font_h//2 or alignY=="top" and y - font_h + 1*scale or y --The same for alignY that y gets the value from "bottom".
  
  print(text, x, y, color, fixed, scale, smallFont)
end

--Show examples
function TIC()
  cls(DARK_GRAY)
  
  line(
    0, POS_Y,
    SCREEN_W, POS_Y,
    LIGHT_GREEN
  )
  
  for alignX, value in pairs(alignTable) do
    
    line(
      value.posX, 0,
      value.posX, SCREEN_H,
      YELLOW
    )
      
    printAlign(
      alignX,
      value.posX, y10,
      alignX, "bottom",
      COLOR_TEXT
    )
  
    printAlign(
      alignX,
      value.posX, y10*2,
      alignX, "bottom",
      COLOR_TEXT,
      true
    )
  
    printAlign(
      alignX,
      value.posX, y10*3,
      alignX, "bottom",
      COLOR_TEXT,
      false,
      1,
      true
    )
  
    printAlign(
      alignX,
      value.posX, y10*4,
      alignX, "bottom",
      COLOR_TEXT,
      false,
      2
    )
  
    printAlign(
      alignX,
      value.posX, y10*5,
      alignX, "bottom",
      COLOR_TEXT,
      false,
      2,
      true
    )
    
    local smallFont = value.alignY == "top" and true or false
    local scale = value.alignY == "middle" and 2 or 1
    printAlign(
      value.alignY,
      value.posX, POS_Y,
      alignX, value.alignY,
      COLOR_TEXT,
      false,
      scale,
      smallFont
    )
  end
end
