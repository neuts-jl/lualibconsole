--------------------------------------------------------------------------------
--  file         : screen.lua
--   Author      : NEUTS JL
--   License     : GPL (GNU General Public License)
--   Date        : 01/02/2024
--
--   Description : ANSI Console Mode Display Routine Library
--
--   This program is free software: you can redistribute it and/or modify it
--   under the terms of the GNU General Public License as published by the Free
--   Software Foundation, either version 3 of the License, or (at your option)
--   any later version.
--
--   This program is distributed in the hope that it will be useful,
--   but WITHOUT ANY WARRANTY; without even the implied warranty of
--   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
--   Public License for more details.
--
--   You should have received a copy of the GNU General Public License along with
--   this program. If not, see <https://www.gnu.org/licenses/>.
---------------------------------------------------------------------------------


Color = {}
Color.BLACK   = 30
Color.RED     = 31
Color.GREEN   = 32
Color.YELLOW  = 33
Color.BLUE    = 34
Color.MAGENTA = 35
Color.CYAN    = 36
Color.WHITE   = 37
Color.GRAY    = 90  
Color.LIGHT_RED     = 91
Color.LIGHT_GREEN   = 92
Color.LIGHT_YELLOW  = 93
Color.LIGHT_BLUE    = 94
Color.LIGHT_MAGENTA = 95
Color.LIGHT_CYAN    = 96
Color.LIGHT_WHITE   = 97


Color.DEFAULT = Color.WHITE

Screen = {}
Screen.__index = Screen

Screen.default_x = 0
Screen.default_y = 25


function Screen:clear()
  io.write("\027[H\027[2J")
--	io.write("\27[H\27[J")
end

function Screen:resetStyle()
  io.write("\27[0m")
end

function Screen:inverseStyle()
  io.write("\27[7m")
end

function Screen:bold()
  io.write("\27[1m")
end

function Screen:underline()
  io.write("\27[4m")
end

function Screen:setCursorPos(x, y)
	io.write("\27[" .. y .. ";" .. x .. "H")
end

function Screen:setCursorOff()
  io.write("\27[?25l")
end

function Screen:setCursorOn()
  io.write("\27[?25h")
end

function Screen:setForeground(color)
  io.write("\27["..color.."m") 
end

function Screen:setBackground(color)
  io.write("\27["..(color+10).."m") 
end

function Screen:defColor()
	self:setForeground(Color.DEFAULT)
end

function Screen:defCursorPos()
	self:setCursor(Screen.default_x, Screen.default_y)
end

function Screen:beep()
  io.write("\7")
end

function Screen:getSize()
  local result = io.popen("mode con"):read("a*")
  
  local lines, columns

  for line in result:gmatch("[^\r\n]+") do
      if string.find(line, "L") then
          local value =  line:match(":%s*(%d+)")
          if value then
              lines = tonumber(value)
          end
      end
      if string.find(line, "C") then
          local value =  line:match(":%s*(%d+)")
          if value then
              columns = tonumber(value)
          end
      end
  end

  return lines or 25, columns or 80
end

