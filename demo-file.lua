--------------------------------------------------------------------------------
--  file         : demo-file.lua
--   Author      : NEUTS JL
--   License     : GPL (GNU General Public License)
--   Date        : 01/02/2024
--
--   Description : Demonstration of the "file" library in console mode  
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


require("file")

print("Demo File library")
local myfile = File.new("example.txt")
myfile:open("w")
myfile:writeln("Hello, World!")
myfile:flush()
myfile:close()

-- Copy and move example
local copiedFile = myfile:copy("example_copy.txt")
myfile:move("example_renamed.txt")
name=io.read()
