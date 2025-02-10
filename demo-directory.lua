--------------------------------------------------------------------------------
--  file         : demo-directory.lua
--   Author      : NEUTS JL
--   License     : GPL (GNU General Public License)
--   Date        : 01/02/2024
--
--   Description : Demonstration of the "directory" library in console mode  
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
                   

require("directory")

print("Demo of Directory object")
-- Example usage:

local dir = Directory:new()

-- Create a new directory
-- dir:make()

-- Move a file or directory
-- dir:move("new_test_dir")

-- Remove an empty file or directory
-- dir:remove()

-- Remove a directory and all its contents
-- dir:removeAll()

-- List directory contents with a filter
local filter = ".*%.lua$"  -- Example filter for Lua files
local contents = dir:list()
for _, file in ipairs(contents) do
    print("Name : " .. file.name)
    print("Is dir : " .. tostring(file.isDir))
    print("Size : " .. file.size)
    print("Modification date : " .. file.date)
    print("Modification time : " .. file.time)
    print("----")
end
