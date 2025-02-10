--------------------------------------------------------------------------------
--  file         : task.lua
--   Author      : NEUTS JL
--   License     : GPL (GNU General Public License)
--   Date        : 01/02/2024
--
--   Description : Manipulation library and process listing
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

Task = {}
Task.__index = Task

function Task:new()
    local newObj = {}
    setmetatable(newObj, self)
    return newObj
end

function Task:list()
    local tasks = {}
    local command

    if Sys:isWindows() then
        command = 'tasklist /fo csv'
    elseif Sys:isLinux() then
        command = 'ps aux'
    else
        error('Unsupported operating system.')
    end

    local result = io.popen(command):read("*a")

    local headerProcessed = false
    for line in result:gmatch("[^\r\n]+") do
        if not headerProcessed then
            headerProcessed = true
        else
            if Sys:isWindows() then
                local name, pid, sessionName, sessionNumber, memUsage = line:match('"([^"]*)","([^"]*)","([^"]*)","([^"]*)","([^"]*)"')
                if name and pid and memUsage then
                    pid = tonumber(pid)
                    memUsage = tonumber(memUsage:match("(%d+)")) / 1024  -- Convertir Kilo-octets en Mo
                    if pid and memUsage then
                        table.insert(tasks, { name = name, pid = pid, cpu=0, memSize = memUsage, memPct=0 })
                    else
                        error("PID/SIZE conversion error : " .. (pid or "nil") .. ", " .. (memUsage or "nil"))
                    end
                else
                    error("Line extract error : " .. (line or "nil"))
                end
            else
                local user, pid, cpu, mem, vsz, rss, tty, stat, start, time, command = line:match("(%S+)%s+(%d+)%s+(%S+)%s+(%S+)%s+(%d+)%s+(%d+)%s+(%S+)%s+(%S+)%s+(%S+)%s+(%S+)%s+(.+)")
                if pid and command then
                    cpu = tonumber(cpu)
                    mem = tonumber(mem)
                    table.insert(tasks, { name = command, pid = tonumber(pid), cpu = cpu, memSize=0, memPct = mem })
                else
                    error("Line extract error : " .. (line or "nil"))
                end
            end
        end
    end
    return tasks
end

function Task:exist(name)
    local command

    if Sys:isWindows() then
        command = 'tasklist /fo csv /nh'
    elseif Sys:isLinux() then
        command = 'pgrep -f ' .. name
    else
        error('Unsupported operating system.')
    end

    local p = io.popen(command)
    local result = p:read("*a")
    p:close()

    if Sys:isWindows() then
        return result:upper():find('"' .. name:upper() .. '"') ~= nil
    else
        return result ~= ""
    end
end

function Task:killByName(name)
    local command

    if Sys:isWindows() then
        if not self:exist(name) then
            return false
        end
        command = 'taskkill /IM "' .. name .. '" /F'
    elseif Sys:isLinux() then
        command = 'pkill -f ' .. name
    else
        error('Unsupported operating system.')
    end

    local result = io.popen(command):read("*a")

    return not self:exist(name)
end

function Task:killByPid(pid)
    local command

    if Sys:isWindows() then
        command = 'taskkill /PID ' .. pid .. ' /F'
    else
        command = 'kill -9 ' .. pid
    end

    local result = io.popen(command):read("*a")
end

