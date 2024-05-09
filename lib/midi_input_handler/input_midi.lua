--[[* * * * * * * * * * * * * * * * * * * 
*                                       *
* Midi Input manager for bugscraper     *
* Using rust lib midir and midi-control *
*                                       *
* -- Corentin Vaillant                  *
* * * * * * * * * * * * * * * * * * * *]] 

require "scripts.util"


local midi = require("lib.midi_input_handler.libmidi_input_handler")
    

local Class = require "scripts.meta.class"

local input_buffer = {}

local midilib = {}


function midilib.update_input()

    local inputs = midi.get_inputs()
    if #inputs == 0 then
        return
    end

    for _, value in pairs(inputs) do
        local key_name = "m_"+tostring(value.note) +"-"+ tostring(value.oct) +"ch"+ tostring(value.channel)
        print(key_name)
        input_buffer[key_name] = value.velocity
    end
    print_table(input_buffer)
end

function midilib.init_midi()
    midi.init_midi()
end

function midilib.is_midi_down(button)
    if input_buffer[button] == nil or input_buffer[button] == 0 then
        return false    
    else
        return true
    end
end


return midilib

---🤓
--[[
Copyright © 2024 <Corentin Vaillant>

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]