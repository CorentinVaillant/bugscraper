require "util"

local function new_source(path, type, args)
	local source = love.audio.newSource("sfx/"..path, type)
	if not args then  return source  end
	
	if args.looping then
		source:setLooping(true)
	end
	return source
end

local sounds = {}

--music_level_1 = new_source("music/level_1.mp3", "stream", {looping = true})
local sfxnames = {
	"jump", "jump1.wav",
	"shot1", "shot1.wav",
	"shot2", "shot2.wav",
	"shot3", "shot3.wav",
	"hurt",  "hurt.wav",
	"land",  "land.wav",
}

for i=1, #sfxnames, 2 do    sounds[sfxnames[i]] = new_source(sfxnames[i+1], "static")    end

return sounds