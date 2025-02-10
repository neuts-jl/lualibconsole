--------------------------------------------------------------------------------
--  file         : demo-form.lua
--   Author      : NEUTS JL
--   License     : GPL (GNU General Public License)
--   Date        : 01/02/2024
--
--   Description : Demonstration of the "form" library in console mode  
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


require('form')

local fields = {
    {name = "name",      prompt = "       Name :",  value = "",   maxlen = 25, required = true,  type = FT.text},
    {name = "firstName", prompt = " First name :",  value = "",   maxlen = 35, required = false, type = FT.text},
    {name = "age",       prompt = "        Age :",  value = "",   maxlen =  3, required = true,  type = FT.integer},
    {name = "size",      prompt = "       Size :",  value = "",   maxlen = 10, required = false, type = FT.decimal}
}

local form =  Form.new(fields, "=== Registration form ===")
form:show()

if not form.cancelled then
    Screen:setForeground(Color.GREEN)
    print("Thank you for registering!")
    
    for _, field in ipairs(form.fields) do
        print(field.prompt .. " " .. field.value)
    end

    local field = form:getFieldByName("name")
    if field then
        print("Name field value : " .. field.value)
    end

    Screen.resetStyle()
end
