--------------------------------------------------------------------------------
--  file         : keyboard.lua
--   Author      : NEUTS JL
--   License     : GPL (GNU General Public License)
--   Date        : 01/02/2024
--
--   Description : Console Mode Keyboard Management Library
--                 Uses https://github.com/neuts-jl/readkey
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


--#include "readkey.exe"

VK = {}
VK.UP        = 0xFF26
VK.PAGE_UP   = 0xFF21
VK.DOWN      = 0xFF28
VK.PAGE_DOWN = 0xFF22
VK.RIGHT     = 0xFF27
VK.LEFT      = 0xFF25
VK.DELETE    = 0xFF2E
VK.INS       = 0xFF2D
VK.BACK      = 0x0008
VK.TAB       = 0x0009
VK.SHIFT_TAB = 0xFF09
VK.RETURN    = 0x000D
VK.ESCAPE    = 0x001B
VK.HOME      = 0xFF24
VK.END       = 0xFF23

VK.F1        = 0xFF70
VK.F2        = 0xFF71
VK.F3        = 0xFF72
VK.F4        = 0xFF73
VK.F5        = 0xFF74
VK.F6        = 0xFF75
VK.F7        = 0xFF76
VK.F8        = 0xFF77
VK.F9        = 0xFF78
VK.F10       = 0xFF79
VK.F11       = 0xFF7A
VK.F12       = 0xFF7B

function readkey()
    local key
    local result = io.popen("readkey.exe"):read("*a")
    return tonumber(result,16)
end