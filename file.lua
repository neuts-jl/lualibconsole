--------------------------------------------------------------------------------
--  file         : file.lua
--   Author      : NEUTS JL
--   License     : GPL (GNU General Public License)
--   Date        : 01/02/2024
--
--   Description : Library of file manipulation tools
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


File = {}
File.__index = File

function File.new(filename)
    local self = setmetatable({}, File)
    self.filename = filename
    self.handle = nil
    return self
end

-- Open the file for read/write/append operations
function File:open(mode)
    mode = mode or "r" -- Default to read mode if not specified
    self.handle, err = io.open(self.filename, mode)
    if not self.handle then
        error("Cannot open file: " .. err)
    end
    return self
end

function File:close()
    if self.handle then
        self.handle:close()
        self.handle = nil
    end
end

function File:write(data)
    if not self.handle then error("File is not open.") end
    return self.handle:write(data)
end

function File:writeln(data)
    if not self.handle then error("File is not open.") end
    return self:write(data .. "\n")
end

function File:read(format)
    if not self.handle then error("File is not open.") end
    format = format or "*a" -- Default to read the entire file
    return self.handle:read(format)
end

function File:readln()
    if not self.handle then error("File is not open.") end
    return self:read("*l")
end

function File:flush()
    if not self.handle then error("File is not open.") end
    return self.handle:flush()
end

function File:remove()
    self:close()
    return os.remove(self.filename)
end

function File:copy(new_filename)
    local source = io.open(self.filename, "rb")
    if not source then error("Cannot open source file.") end
    local dest = io.open(new_filename, "wb")
    if not dest then
        source:close()
        error("Cannot open destination file.")
    end
    local content = source:read("*a")
    dest:write(content)
    source:close()
    dest:close()
    return File.new(new_filename)
end

function File:move(new_filename)
    local success, err = os.rename(self.filename, new_filename)
    if success then
        self.filename = new_filename
    end
    return success, err
end

