local function rgb(r,g,b)
	return {r/255, g/255, b/255, 1}
end

local function color(hex)
	if not hex then  return  {1.0, 1.0, 1.0}  end
	if type(hex) ~= "number" then  return {1.0, 1.0, 1.0}  end

	local b = hex % 256;  hex = (hex - b) / 256
	local g = hex % 256;  hex = (hex - b) / 256
	local r = hex % 256
	return {r/255, g/255, b/255}
end

CANVAS_WIDTH = 480
CANVAS_HEIGHT = 270

--------------------------------------------- 

BLOCK_WIDTH = 16
BW = BLOCK_WIDTH

--------------------------------------------- 

FONT_CHARACTERS = 
    " !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz"..
    "{|}~ ¡¢£©®°¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõöøùúûüýþÿŒœŸЁАБВГДЕЖЗИЙКЛМНО"..
    "ПРСТУФХЦЧШЩЪЫЬЭЮЯабвгдежзийклмнопрстуфхцчшщъыьэюяё€🔊🔉🔈🎵🎼🔳🔲📺🕐↖🛜▶⏸🔄🔘⬅➡⬆⬇⏏🔫🔚👆🔙⌨🎮🎚❤"..
    "✅❎🐜"

--------------------------------------------- 

MAX_NUMBER_OF_PLAYERS = 4

--------------------------------------------- 

COL_WHITE = {1, 1, 1, 1}
COL_BLACK = {0, 0, 0, 1}
COL_RED = {1, 0, 0, 1}
COL_YELLOW = {1, 1, 0, 1}
COL_GREEN = {0, 1, 0, 1}
COL_CYAN = {0, 1, 1, 1}
COL_BLUE = {0, 0, 1, 1}
COL_MAGENTA = {1, 0, 1, 1}

-- Reference is EDG32 palette
COL_VERY_DARK_GRAY = rgb(38, 43, 68)
COL_DARK_GRAY = rgb(58, 68, 102)
COL_MID_GRAY = color(0x5a6988)
COL_LIGHT_GRAY = color(0x8b9bb4)
COL_LIGHTEST_GRAY = color(0xc0cbdc)

COL_DARK_RED = rgb(158, 40, 53)
COL_LIGHT_RED = color(0xe43b44)
COL_PINK = color(0xf6757a)

COL_YELLOW_ORANGE = color(0xfeae34)
COL_ORANGE = color(0xf77622)

COL_LIGHT_BROWN = color(0xb86f50)
COL_MID_BROWN = color(0x743f39)
COL_DARK_BROWN = rgb(63, 40, 50)

COL_LIGHT_YELLOW = color(0xfee761)

COL_LIGHT_GREEN = color(0x63c74d)
COL_MID_GREEN = color(0x3e8948)
COL_MID_DARK_GREEN = color(0x265c42)
COL_DARK_GREEN = color(0x193c3e)

COL_SKY = rgb(104, 174, 212)

COL_BLACK_BLUE = rgb(24, 20, 37)
COL_DARK_BLUE = rgb(18, 78, 137)
COL_MID_BLUE = rgb(0, 149, 233)
COL_LIGHT_BLUE = color(0x2ce8f5)

COL_DARK_PURPLE = rgb(104, 56, 108)

SELECTED_HIGHLIGHT_COLOR = COL_LIGHT_RED
LOGO_COLS = {COL_LIGHT_YELLOW, COL_LIGHT_BLUE, COL_LIGHT_RED}

---------------------------------------------

MENU_PADDING = CANVAS_WIDTH * 0.25

---------------------------------------------

GAME_STATE_WAITING = "waiting"
GAME_STATE_PLAYING = "playing"
GAME_STATE_DYING = "dying"
GAME_STATE_ELEVATOR_BURNING = "elevator_burning"
GAME_STATE_WIN = "win"

---------------------------------------------

COLLISION_TYPE_SOLID = "solid"
COLLISION_TYPE_SEMISOLID = "semisolid"

---------------------------------------------

MAX_ASSIGNABLE_BUTTONS = 8

INPUT_TYPE_KEYBOARD = "k"
INPUT_TYPE_CONTROLLER = "c"

BUTTON_STYLE_SWITCH = "switch"
BUTTON_STYLE_PLAYSTATION4 = "playstation4"
BUTTON_STYLE_PLAYSTATION5 = "playstation5"
BUTTON_STYLE_XBOX = "xbox"
BUTTON_STYLE_GENERIC = "generic"
BUTTON_STYLE_DETECT = "detect"
BUTTON_STYLES = {
	BUTTON_STYLE_SWITCH,
	BUTTON_STYLE_PLAYSTATION4,
	BUTTON_STYLE_PLAYSTATION5,
	BUTTON_STYLE_XBOX,
	BUTTON_STYLE_DETECT,
}
CONTROLLER_BRANDS = {
    BUTTON_STYLE_SWITCH,
    BUTTON_STYLE_PLAYSTATION4,
    BUTTON_STYLE_PLAYSTATION5, 
    BUTTON_STYLE_XBOX,
}

BUTTON_HOLD_REPEAT_TIME = 0.35
BUTTON_HOLD_REPEAT_INTERVAL = 0.07

RAW_INPUT_MAP_DEFAULT_EMPTY = {
    left =      {},
    right =     {},
    up =        {},
    down =      {},
    jump =      {},
    shoot =     {},
    pause =     {},
    
    ui_select = {},
    ui_back =   {},
    ui_left =   {},
    ui_right =  {},
    ui_up =     {},
    ui_down =   {},
    ui_reset_keys = {},
    split_keyboard = {},
    leave_game = {},

    debug = {}
}

RAW_INPUT_MAP_DEFAULT_GLOBAL = {
    left =      {},
    right =     {},
    up =        {},
    down =      {},
    jump =      {"k_c", "k_b", "c_a", "c_b"},
    shoot =     {},
    pause =     {},
    
    ui_select = {},
    ui_back =   {},
    ui_left =   {},
    ui_right =  {},
    ui_up =     {},
    ui_down =   {},
    ui_reset_keys = {},
    split_keyboard = {"k_return"},
    leave_game = {},

    debug = {"k_f1", "c_back"},
}

RAW_INPUT_MAP_DEFAULT_CONTROLLER = {
    left =      {"c_leftstickxneg", "c_dpleft"},
    right =     {"c_leftstickxpos", "c_dpright"},
    up =        {"c_leftstickyneg", "c_dpup"},
    down =      {"c_leftstickypos", "c_dpdown"},
    jump =      {"c_a", "c_b"},
    shoot =     {"c_x", "c_y", "c_righttrigger"},
    pause =     {"c_start"},
    
    ui_select = {"c_a"},
    ui_back =   {"c_b"},
    ui_left =   {"c_leftstickxneg", "c_dpleft"},
    ui_right =  {"c_leftstickxpos", "c_dpright"},
    ui_up =     {"c_leftstickyneg", "c_dpup"},
    ui_down =   {"c_leftstickypos", "c_dpdown"},
    ui_reset_keys = {"c_lefttrigger"},
    split_keyboard = {},
    leave_game = {"c_lefttrigger"},

    debug = {},
}

RAW_INPUT_MAP_DEFAULT_KEYBOARD_SOLO = {
    left =      {"k_left", "k_a"},
    right =     {"k_right", "k_d"},
    up =        {"k_up", "k_w"},
    down =      {"k_down", "k_s"},
    jump =      {"k_c", "k_b"},
    shoot =     {"k_x", "k_v"},
    pause =     {"k_escape", "k_p"},
    
    ui_select = {"k_c", "k_b", "k_return"},
    ui_back =   {"k_x", "k_escape", "k_backspace"},
    ui_left =   {"k_left", "k_a"},
    ui_right =  {"k_right", "k_d"},
    ui_up =     {"k_up", "k_w"},
    ui_down =   {"k_down", "k_s"},
    ui_reset_keys = {"k_tab"},
    split_keyboard = {},
    leave_game = {"k_tab"},

    debug = {},
}

RAW_INPUT_MAP_DEFAULT_SPLIT_KEYBOARD_P1 = {
    left =      {"k_a"},
    right =     {"k_d"},
    up =        {"k_w"},
    down =      {"k_s"},
    jump =      {"k_f"},
    shoot =     {"k_g"},
    pause =     {"k_escape", "k_p"},
    
    ui_select = {"k_f"},
    ui_back =   {"k_g", "k_escape"},
    ui_left =   {"k_a"},
    ui_right =  {"k_d"},
    ui_up =     {"k_w"},
    ui_down =   {"k_s"},
    ui_reset_keys = {"k_tab"},
    split_keyboard = {},
    leave_game = {"k_tab"},

    debug = {},
}

RAW_INPUT_MAP_DEFAULT_SPLIT_KEYBOARD_P2 = {
    left =      {"k_left"},--"k_h"
    right =     {"k_right"},--"k_k"
    up =        {"k_up"},--"k_u"
    down =      {"k_down"},--"k_j"
    jump =      {"k_l"},
    shoot =     {"k_;"},
    pause =     {"k_escape", "k_p"},
    
    ui_select = {"k_l", "k_return"},
    ui_back =   {"k_;", "k_backspace"},
    ui_left =   {"k_h", "k_left"},
    ui_right =  {"k_k", "k_right"},
    ui_up =     {"k_u", "k_up"},
    ui_down =   {"k_j", "k_down"},
    ui_reset_keys = {"k_o"},
    split_keyboard = {},
    leave_game = {"k_o"},

    debug = {},
}

UI_ACTIONS = {"ui_up", "ui_down", "ui_left", "ui_right", "ui_select", "ui_back", "pause"}

AXIS_TABLE = {
    leftstickxpos =  true,
    leftstickxneg =  true,
    leftstickypos =  true,
    leftstickyneg =  true,

    rightstickxpos = true,
    rightstickxneg = true,
    rightstickypos = true,
    rightstickyneg = true,

    lefttrigger =    true,
    righttrigger =   true,
}

AXIS_DEADZONE = 0.2
TRIGGER_DEADZONE = 0.2
AXIS_ANGLE_MARGIN = 3 * math.pi/8
UI_AXIS_ANGLE_MARGIN = 2 * math.pi/8
AXIS_TO_KEY_NAME_MAP = {
    ["leftx+"] = "leftstickxpos",
    ["leftx-"] = "leftstickxneg",
    ["lefty+"] = "leftstickypos",
    ["lefty-"] = "leftstickyneg",

    ["rightx+"] = "rightstickxpos",
    ["rightx-"] = "rightstickxneg",
    ["righty+"] = "rightstickypos",
    ["righty-"] = "rightstickyneg",

    ["triggerleft+"] = "lefttrigger",
    ["triggerleft-"] = "lefttrigger",
    ["triggerright+"] = "righttrigger",
    ["triggerright-"] = "righttrigger",
}

GLOBAL_INPUT_USER_PLAYER_N = -1

KEY_CONSTANT_TO_IMAGE_NAME = {
	["unknown"] = "btn_k_unknown",

	["a"] = "btn_k_a",
	["b"] = "btn_k_b",
	["c"] = "btn_k_c",
	["d"] = "btn_k_d",
	["e"] = "btn_k_e",
	["f"] = "btn_k_f",
	["g"] = "btn_k_g",
	["h"] = "btn_k_h",
	["i"] = "btn_k_i",
	["j"] = "btn_k_j",
	["k"] = "btn_k_k",
	["l"] = "btn_k_l",
	["m"] = "btn_k_m",
	["n"] = "btn_k_n",
	["o"] = "btn_k_o",
	["p"] = "btn_k_p",
	["q"] = "btn_k_q",
	["r"] = "btn_k_r",
	["s"] = "btn_k_s",
	["t"] = "btn_k_t",
	["u"] = "btn_k_u",
	["v"] = "btn_k_v",
	["w"] = "btn_k_w",
	["x"] = "btn_k_x",
	["y"] = "btn_k_y",
	["z"] = "btn_k_z",
	["0"] = "btn_k_0",
	["1"] = "btn_k_1",
	["2"] = "btn_k_2",
	["3"] = "btn_k_3",
	["4"] = "btn_k_4",
	["5"] = "btn_k_5",
	["6"] = "btn_k_6",
	["7"] = "btn_k_7",
	["8"] = "btn_k_8",
	["9"] = "btn_k_9",
	["space"] = "btn_k_space",
	["!"] = "btn_k_exclamationmark",
	["\""] = "btn_k_doublequote",
	["#"] = "btn_k_hash",
	["$"] = "btn_k_dollar",
	["&"] = "btn_k_ampersand",
	["'"] = "btn_k_singlequote",
	["("] = "btn_k_leftparenthesis",
	[")"] = "btn_k_rightparenthesis",
	["*"] = "btn_k_asterisk",
	["+"] = "btn_k_plus",
	[","] = "btn_k_comma",
	["-"] = "btn_k_minus",
	["."] = "btn_k_period",
	["/"] = "btn_k_slash",
	[":"] = "btn_k_colon",
	[";"] = "btn_k_semicolon",
	["<"] = "btn_k_lessthan",
	[">"] = "btn_k_greaterthan",
	["="] = "btn_k_equal",
	["?"] = "btn_k_questionmark",
	["@"] = "btn_k_at",
	["["] = "btn_k_leftsquarebracket",
	["]"] = "btn_k_rightsquarebracket",
	["\\"] = "btn_k_backslash",
	["^"] = "btn_k_caret",
	["_"] = "btn_k_underscore",
	["`"] = "btn_k_backtick",
	["right"] = "btn_k_right",
	["left"] = "btn_k_left",
	["down"] = "btn_k_down",
	["up"] = "btn_k_up",
	["insert"] = "btn_k_insert",
	["backspace"] = "btn_k_backspace",
	["tab"] = "btn_k_tab",
	["return"] = "btn_k_enter",
	["delete"] = "btn_k_delete",
	["f1"] = "btn_k_f1",
	["f2"] = "btn_k_f2",
	["f3"] = "btn_k_f3",
	["f4"] = "btn_k_f4",
	["f5"] = "btn_k_f5",
	["f6"] = "btn_k_f6",
	["f7"] = "btn_k_f7",
	["f8"] = "btn_k_f8",
	["f9"] = "btn_k_f9",
	["f10"] = "btn_k_f10",
	["f11"] = "btn_k_f11",
	["f12"] = "btn_k_f12",
	["capslock"] = "btn_k_capslock",
	["rshift"] = "btn_k_rshift",
	["lshift"] = "btn_k_lshift",
	["lctrl"] = "btn_k_lctrl",
	["rctrl"] = "btn_k_rctrl",
	["lalt"] = "btn_k_lalt",
	["ralt"] = "btn_k_ralt",
	["kp0"] = "btn_k_kp0",
	["kp1"] = "btn_k_kp1",
	["kp2"] = "btn_k_kp2",
	["kp3"] = "btn_k_kp3",
	["kp4"] = "btn_k_kp4",
	["kp5"] = "btn_k_kp5",
	["kp6"] = "btn_k_kp6",
	["kp7"] = "btn_k_kp7",
	["kp8"] = "btn_k_kp8",
	["kp9"] = "btn_k_kp9",
	["kp."] = "btn_k_kpdot",
	["kp,"] = "btn_k_kpcomma",
	["kp/"] = "btn_k_kpslash",
	["kp*"] = "btn_k_kpasterisk",
	["kp-"] = "btn_k_kpminus",
	["kp+"] = "btn_k_kpplus",
	["kpenter"] = "btn_k_kpenter",
	["kp="] = "btn_k_kpequals",
	["escape"] = "btn_k_escape",
}

CONTROLLER_BUTTONS = {
    ["a"] = true,
    ["b"] = true,
    ["x"] = true,
    ["y"] = true,
    ["back"] = true,
    ["start"] = true,
    ["leftstick"] = true,
    ["rightstick"] = true,
    ["leftshoulder"] = true,
    ["rightshoulder"] = true,
    ["dpup"] = true,
    ["dpdown"] = true,
    ["dpleft"] = true,
    ["dpright"] = true,
    ["misc1"] = true,
    ["paddle1"] = true,
    ["paddle2"] = true,
    ["paddle3"] = true,
    ["paddle4"] = true,
    ["touchpad"] = true,
    ["leftstickxpos"] = true,
    ["leftstickxneg"] = true,
    ["leftstickypos"] = true,
    ["leftstickyneg"] = true,
    ["rightstickxpos"] = true,
    ["rightstickxneg"] = true,
    ["rightstickypos"] = true,
    ["rightstickyneg"] = true,
    ["lefttrigger"] = true,
    ["righttrigger"] = true,
}

--------------------------------------------- 

MUSIC_MODE_OFF = "off"
MUSIC_MODE_INGAME = "ingame"
MUSIC_MODE_PAUSE = "pause"

--------------------------------------------- 

UPGRADE_TYPE_TEMPORARY = "temporary"
UPGRADE_TYPE_INSTANT = "instant"
UPGRADE_TYPE_PERMANENT = "permanent"

UPGRADE_TARGET_SINGLE = "single"
UPGRADE_TARGET_ALL = "all"

--------------------------------------------- 

SMASH_EASTER_EGG_PROBABILITY = 1/50