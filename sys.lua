--------------------------------------------------------------------------------
--  file         : sys.lua
--   Author      : NEUTS JL
--   License     : GPL (GNU General Public License)
--   Date        : 01/02/2024
--
--   Description : System Functions Library
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


Sys = {}
Sys.__index = Sys

function Sys:new()
    local newObj = {}
    setmetatable(newObj, self)
    return newObj
end

function Sys:isWindows()
    return package.config:sub(1,1) == '\\'
end

function Sys:isLinux()
    return package.config:sub(1,1) == '/'
end

function Sys:getCurrentDir()
    local command
    local currentDir
    if _APP_PATH == nil then
        if Sys:isWindows() then
            command = "cd" 
        else
            command = "pwd"
        end    
        currentDir = io.popen(command):read("*l")
    else
        currentDir = _APP_PATH    
    end    
    return currentDir
end

function Sys:setCurrentDir(newDir)
    local command

    if Sys:isWindows() then
        command = 'cd /d "' .. newDir .. '"' 
    else
        command = 'cd "' .. newDir .. '" && pwd' 
    end

    local success = os.execute(command)

    if success ~= 0 then
        error("Impossible de changer de répertoire.")
    end
    
    return success == 0
end

