--------------------------------------------------------------------------------
--  file         : demo-task.lua
--   Author      : NEUTS JL
--   License     : GPL (GNU General Public License)
--   Date        : 01/02/2024
--
--   Description : Demonstration of the "task" library in console mode  
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


require('task')

-- Example usage:
local sys = Sys.new()
local task = Task:new()

print("Liste des tâches en cours :")
local taskList = task:list()
for _, t in ipairs(taskList) do
--    print(string.format("Nom: %s, PID: %d, CPU: %.2f%%, Mémoire: %d %.2f%%" , t.name, t.pid, t.cpu, t.memSize, t.memPct))    
    print(string.format("Nom: %s, PID: %d, CPU: %.2f%%" , t.name, t.pid, t.cpu))    
end

print('Vérifier si une tâche existe')
local taskName = "notepad.exe"  -- Remplacez par le nom de la tâche à vérifier
if task:exist(taskName) then
    print("La tâche '" .. taskName .. "' existe.")
else
    print("La tâche '" .. taskName .. "' n'existe pas.")
end

print('Killer la tâche par nom')
if task:killByName(taskName) then
    print("La tâche '" .. taskName .. "' a été tuée.")
else
    print("La tâche '" .. taskName .. "' n'a pas pu être tuée.")
end

print('Killer la tâche par PID')
-- Remplacez par un PID valide pour tester
local pid = 1234
task:killByPid(pid)
