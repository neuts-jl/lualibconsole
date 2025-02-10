--------------------------------------------------------------------------------
--  file         : directory.lua
--   Author      : NEUTS JL
--   License     : GPL (GNU General Public License)
--   Date        : 01/02/2024
--
--   Description : Library of manipulation tools and directory listing
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


require("sys")

Directory = {}
Directory.__index = Directory

function Directory:new(path)
    if path == nil then
        path = Sys.getCurrentDir()   
    end    
    local newObj = { path = path }
    setmetatable(newObj, self)
    return newObj
end

function Directory:list(filter)
    local files = {}

    local path = self.path
    local command

    if Sys:isWindows() then
        command = 'dir "' .. path .. '" /a /o:n /-c'
    elseif Sys:isLinux() then
        command = 'ls -l "' .. path .. '"'
    else
        error("Unsupported operating system.")
    end

    local p = io.popen(command)
    local header = true

    for line in p:lines() do
        if Sys:isWindows() then
            if header then
                if line:match("^----") then
                    header = false
                end
            else
                local date, time, size, name 
                local isDir = line:match("<DIR>")
                if isDir then
                    name = line:match("%s+<DIR>%s+(.*)")
                    size = ""
                    date = ""
                    time = ""
                else
                    date, time, size, name = line:match("(%d+/%d+/%d+)%s+(%d+:%d+%s*%a*)%s+([%d,]*)%s+(.*)")
                end
                if name and (not filter or name:match(filter)) then
                    local file = {
                        name = name,
                        isDir = isDir ~= nil, 
                        size = size,
                        date = date,
                        time = time
                    }
                    table.insert(files, file)
                end
            end
        elseif Sys:isLinux() then
            local permissions, links, owner, group, size, month, day, time, name
            permissions, links, owner, group, size, month, day, time, name = line:match("(%S+)%s+(%d+)%s+(%S+)%s+(%S+)%s+(%d+)%s+(%S+)%s+(%d+)%s+(%S+)%s+(.*)")
            if name and (not filter or name:match(filter)) then
                local isDir = permissions:sub(1,1) == 'd' 
                local file = {
                    name = name,
                    isDir = isDir,
                    size = size or "-",
                    date = month .. " " .. day or "Unknown",
                    time = time or "Unknown"
                }
                table.insert(files, file)
            end
        end
    end

    p:close()
    return files
end

function Directory:make()
    local path = self.path
    local command

    if Sys:isWindows() then
        command = 'mkdir "' .. path .. '"'
    elseif Sys:isLinux() then
        command = 'mkdir -p "' .. path .. '"'
    else
        error("Unsupported operating system.")
    end

    os.execute(command)
end

function Directory:remove()
    local path = self.path
    local command

    if Sys:isWindows() then
        command = 'rmdir /Q "' .. path .. '"'
    elseif Sys:isLinux() then
        command = 'rmdir "' .. path .. '"'
    else
        error("Unsupported operating system.")
    end

    os.execute(command)
end

function Directory:removeAll()
    local path = self.path
    local command

    if Sys:isWindows() then
        command = 'rmdir /S /Q "' .. path .. '"'
    elseif Sys:isLinux() then
        command = 'rm -r "' .. path .. '"'
    else
        error("Unsupported operating system.")
    end

    os.execute(command)
end

function Directory:move(dest)
    local src = self.path
    local command

    if Sys:isWindows() then
        command = 'move "' .. src .. '" "' .. dest .. '"'
    elseif Sys:isLinux() then
        command = 'mv "' .. src .. '" "' .. dest .. '"'
    else
        error("Unsupported operating system.")
    end

    os.execute(command)
end
