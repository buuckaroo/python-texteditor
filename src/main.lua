--main.lua
local ui = require('ui')
local sys = require('sys')

--application variables
local file = false

--user interface
local window = ui.Window('Python Text-Editor', 'fixed', 1280, 720)

local text_editor = ui.Edit(window, '', 0, 50, 860, 650)
local output = ui.Edit(window, '', 870, 50, 400, 650)

text_editor.font = "Courier New"
text_editor.fontsize = 16
text_editor.wordwrap = true

output.font = "Courier New"

local about_label = ui.Label(window, '--------- OPEN A FILE ---------', 0, 35)
local output_label = ui.Label(window, '--------- CONSOLE OUTPUT ---------', 870, 35)

local open_file = ui.Button(window, 'Open file', 0, 0)
local save_file = ui.Button(window, 'Save file', 60, 0)
local run_file = ui.Button(window, 'Run file', 115, 0)
--|
--V
open_file.onClick = function(self)
  local instance = ui.opendialog('Select a Python file', false, 'Python files (*.py;*.pyw;*.pyi)|*.py;*.pyw;*.pyi|')
  if instance ~= nil then
    file = instance
    text_editor:load(file)
  else
    file = false
    ui.warn('Error with File', 'Error Window')
  end
end
--|
--V
save_file.onClick = function(self)
  if file ~= false then
    text_editor:save(file)
  else
    ui.warn('Open a python file', 'Error Window')
  end
end
--|
--V
run_file.onClick = function(self)
  if file ~= false then
    local pipe = sys.Pipe('cmd.exe')
    pipe:read(100)
    pipe:write('py ' .. file.name .. '\n')
    
    pipe:read(200)
    local results = await(pipe:read())
    
    output.text = results
    
    pipe:close()
  else
    ui.warn('Open a python file', 'Error Window')
  end
end

--update loop
window:show()
repeat
  ui.update()
until not window.visible