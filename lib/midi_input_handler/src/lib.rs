mod midi_handler;

use std::thread;

use midi_handler::*;
use mlua::prelude::*;

static mut BUFFER: Vec<MidiInputPressed> = vec![];

//LUA functions

//same name as the lib (path include...)
#[mlua::lua_module]
fn libmidi_input_handler(lua: &Lua) -> LuaResult<LuaTable> {
    lua_init(lua)
}
#[mlua::lua_module]
fn target_debug_libmidi_input_handler(lua: &Lua) -> LuaResult<LuaTable> {
    lua_init(lua)
}
#[mlua::lua_module]
fn libmidi_input_handler_libmidi_input_handler(lua: &Lua) -> LuaResult<LuaTable> {
    lua_init(lua)
}

#[mlua::lua_module]
fn lib_midi_input_handler_libmidi_input_handler(lua: &Lua) -> LuaResult<LuaTable> {
    lua_init(lua)
}

#[mlua::lua_module]
fn lua_init(lua: &Lua) -> LuaResult<LuaTable> {
    let exports = lua.create_table()?;
    exports.set("print_rust", lua.create_function(lua_print_rust)?)?;
    exports.set("init_midi", lua.create_function(lua_init_midi)?)?;
    exports.set("get_inputs", lua.create_function(lua_get_inputs)?)?;

    Ok(exports)
}

//test function
fn lua_print_rust(_: &Lua, message: String) -> LuaResult<()> {
    println!("[rust] {message}");
    Ok(())
}

fn lua_init_midi(lua: &Lua, _: ()) -> LuaResult<LuaTable> {
    let input_table = lua.create_table()?;
    thread::spawn(|| {
        let receiver = init();
        loop {
            let input = receiver.recv();
            unsafe {
                BUFFER.push(input.unwrap()); //TODO handle unwrap
            }
        }
    });

    Ok(input_table)
}

//renvoie None ou les inputs d'un buffer
fn lua_get_inputs(lua: &Lua, _: ()) -> LuaResult<LuaTable> {
    let buffer_table = lua.create_table()?;
    print!("{}", unsafe { BUFFER.len() });
    for (i, input) in unsafe { BUFFER.iter().enumerate() } {
        buffer_table.set(i, midi_input_to_table(lua, input)?)?;
    }
    println!(" -> {}", unsafe { BUFFER.len() });
    Ok(buffer_table)
}

//---------------------

fn midi_input_to_table<'a>(lua: &'a Lua, input: &'a MidiInputPressed) -> LuaResult<LuaTable<'a>> {
    let input_table= lua.create_table()?;
    match input {
        MidiInputPressed::Note(note) => {
            input_table.set("midi_type", "note")?;
            input_table.set("oct", note.oct)?;
            input_table.set("note", note.note)?;
            input_table.set("velocity", note.velocity)?;
            input_table.set("channel", note.get_channel_num())?;
        }
        MidiInputPressed::JoystickX(midi_val) => {
            midival_into_table(&input_table, midi_val, "JoystickX".to_string())?
        }
        MidiInputPressed::JoystickY(midi_val) => {
            midival_into_table(&input_table, midi_val, "JoystickY".to_string())?
        }
        MidiInputPressed::Knob(midi_val) => {
            midival_into_table(&input_table, midi_val, "Knob".to_string())?
        }
        MidiInputPressed::Unknow(midi_val) => {
            input_table.set("midi_type", "unknown")?;
            input_table.set("id", *midi_val)?;
        }

        MidiInputPressed::None => (),
    }

    Ok(input_table)
}

fn midival_into_table(
    input_table: &LuaTable,
    midi_val: &MidiValue,
    midi_type: String,
) -> LuaResult<()> {
    input_table.set("midi_type", midi_type)?;
    input_table.set("value", midi_val.value)?;
    input_table.set("key", midi_val.key)?;
    input_table.set("channel", midi_val.get_channel_num())?;

    Ok(())
}
