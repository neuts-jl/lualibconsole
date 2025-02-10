--------------------------------------------------------------------------------
--  file         : form.lua
--   Author      : NEUTS JL
--   License     : GPL (GNU General Public License)
--   Date        : 01/02/2024
--
--   Description : Library of console mode form manipulation tools
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


require("screen")
require("keyboard")

FT={}
FT.text    = 0
FT.integer = 1
FT.decimal = 2

Form = {}
Form.__index = Form

function Form.new(fields, title,  x, y)
    local self = setmetatable({}, Form)
    self.fields = fields or {}
    self.title = title or "=== Form ==="
    self.width = 40
    self.height = 10 
    self.x = x 
    self.y = y  
    self.current_field = 1
    self.cancelled = false
    self.color={}
    self.color.background=Color.LIGHT_YELLOW
    self.color.error=Color.RED
    self.color.title=Color.BLACK
    self.color.prompt=Color.CYAN
    self.color.field=Color.WHITE
    self:computeSize()
    return self
end

function Form:computeSize()
    local w=0
    local y=2
    for _, field in ipairs(self.fields) do
        w= math.max(w,#field.prompt+field.maxlen+4)
        field.y=y
        field.x=2
        y=y+2
    end
    w=math.max(w,#self.title+2)
    self.width=w
    self.height=y+1
    if self.x == nil or self.y == nil then
        local r,c = Screen:getSize()
        if self.x == nil  then
            self.x=math.floor((c-self.width) / 2)
        end
        if self.y == nil  then
            self.y=math.floor((r-self.height) / 2)
        end
    end    
end

function Form:displayField(field, is_selected)
    local x = self.x + field.x 
    local y = self.y + field.y 
    Screen:setCursorPos(x, y)
    Screen:setForeground(self.color.prompt)
    Screen:setBackground(self.color.background)
    if is_selected then
        Screen:inverseStyle()  
    end
    
    io.write(field.prompt)
    
    Screen:resetStyle()
    Screen:setForeground(self.color.field)
    Screen:underline()
    Screen:setCursorPos(x + #field.prompt + 1, y)
    io.write(string.rep(" ", field.maxlen))
    Screen:setCursorPos(x + #field.prompt + 1, y)
    io.write(field.value)
    
    Screen:resetStyle()
end

function Form:handleFieldInput(field)
    Screen.setCursorOn()    
    local input = readkey()
    Screen.setCursorOff()

    if input == VK.BACK or input == VK.DELETE then
        if #field.value > 0 then
            field.value = field.value:sub(1, -2) 
        end
    elseif input == VK.TAB or input == VK.DOWN then
        return "tab"
    elseif input == VK.UP then
        return "shift-tab"
    elseif input == VK.RETURN then
        return "return"
    elseif input == VK.ESCAPE then  
        self.cancelled = true
        return "cancel"
    elseif input >= 0x0020 and input <= 0x007F then
        if #field.value < field.maxlen then
            local newChar = string.char(input)
            if field.type == FT.integer then
                if newChar:match("%d") then
                    field.value = field.value .. newChar
                else
                    self:showError("Number only")
                    Screen:beep()    
                end
            elseif field.type == FT.decimal then
                if newChar:match("[%d.]") then
                    if not field.value:find("%.") or newChar ~= "." then
                        field.value = field.value .. newChar
                    else
                        self:showError("Decimal only")
                        Screen:beep()    
                    end
                else
                    self:showError("Decimal only")
                    Screen:beep()    
                end
            elseif field.type == FT.text then
                field.value = field.value .. newChar
            end
        end
    end

    return nil
end

function Form:validateForm()
    for i, field in ipairs(self.fields) do
        if field.required and field.value == "" then
            self.current_field = i
            return false, field.prompt .. " is required."
        end
        
        if field.value~="" and field.type == FT.integer and not tonumber(field.value) then
            self.current_field = i
            return false, field.prompt .. " must be an integer."
        end
        
        if  field.value~="" and field.type == FT.decimal and (not tonumber(field.value) or field.value:find("[^%d.]")) then
            self.current_field = i
            return false, field.prompt .. " must be an décimal."
        end
    end
    return true, nil
end

function Form:addField(field)
    table.insert(self.fields, field)
end

function Form:getFieldByName(name)
    for _, field in ipairs(self.fields) do
        if field.name == name then
            return field
        end
    end
    return nil
end

function Form:displayBackground()
    for row = self.y, self.y + self.height do
        Screen:setCursorPos(self.x, row)
        Screen:setBackground(self.color.background)
        io.write(string.rep(" ", self.width))
    end
    Screen:resetStyle()
end

function Form:showError(error_message)
    local function padMessage(msg, length)
        length = length or 30  -- Longueur cible
        if #msg < length then
            return msg .. string.rep(" ", length - #msg)  -- Ajoute des espaces
        else
            return msg:sub(1, length)  -- Tronque si nécessaire
        end
    end

    Screen:setCursorPos(self.x + 2, self.y + self.height-1)
    Screen:setForeground(self.color.error)
    Screen:setBackground(self.color.background)
    io.write(padMessage(error_message,self.width-4))
    Screen:resetStyle()
end

function Form:show()
    Screen:clear()
    Screen.setCursorOff()
    
    self:displayBackground()

    local title_col = self.x + math.floor((self.width - #self.title) / 2)
    Screen:setCursorPos(title_col, self.y)
    Screen:setBackground(self.color.background)
    Screen:setForeground(self.color.title)
    Screen:bold()
    io.write(self.title)
    Screen:resetStyle()
    
    while not self.cancelled do
        for i, field in ipairs(self.fields) do
            self:displayField(field, i == self.current_field)
        end

        for i, field in ipairs(self.fields) do
            if i == self.current_field then
                local cursor_x = self.x + field.x + #field.prompt + 1 + #field.value
                Screen:setCursorPos(cursor_x, self.y + field.y)
                break
            end
        end

        local action = self:handleFieldInput(self.fields[self.current_field])
        
        if action == "tab" then
            self.current_field = self.current_field % #self.fields + 1
        elseif action == "shift-tab" then
            self.current_field = (self.current_field - 2) % #self.fields + 1
        elseif action == "return" then
            local is_valid, error_message = self:validateForm()
            if is_valid then
                break
            else
                self:showError(error_message)
                self:displayField(self.fields[self.current_field], true)
            end
        elseif action == "cancel" then
            self.cancelled = true
            break
        end
    end

    Screen:clear()
    Screen:setCursorOn()
    Screen:resetStyle()
end

