mod midi_handler;

use midi_handler::*;
use mlua::prelude::*;


//same name as the lib (path include...)
#[mlua::lua_module] fn libmidi_input_handler(lua: &Lua) -> LuaResult<LuaTable> {lua_init(lua)}
#[mlua::lua_module] fn target_debug_libmidi_input_handler(lua: &Lua) -> LuaResult<LuaTable> {lua_init(lua)}
#[mlua::lua_module] fn libmidi_input_handler_libmidi_input_handler(lua: &Lua) -> LuaResult<LuaTable> {lua_init(lua)}

#[mlua::lua_module] fn lib_midi_input_handler_libmidi_input_handler(lua: &Lua) -> LuaResult<LuaTable> {lua_init(lua)}

#[mlua::lua_module]
fn lua_init(lua: &Lua) -> LuaResult<LuaTable> {
    let exports = lua.create_table()?;
    exports.set("print_rust", lua.create_function(lua_print_rust)?)?;
    exports.set("init_midi", lua.create_function(lua_init_midi)?)?;
    Ok(exports)
}

//test function
fn lua_print_rust(_: &Lua, message: String) -> LuaResult<()> {
    println!("[rust] {message}");
    Ok(())
}

//function that I want to use
fn lua_init_midi(_: &Lua,table :LuaTable) -> LuaResult<()> {
    init();

    Ok(())
}


//table to informe that a button has a value
fn MidiInputPressedToTable(input : MidiInputPressed,lua: &Lua)->LuaResult<LuaTable>{
    let table = lua.create_table()?;

    
    //grrrr fonctionne pas
    //TODO

    
    
    Ok(table)
}
