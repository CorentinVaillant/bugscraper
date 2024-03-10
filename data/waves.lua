require "scripts.util"
local Class = require "scripts.meta.class"
local Gun = require "scripts.game.gun"
local images = require "data.images"
local E = require "data.enemies"

local waves = {

{ -- 1
	min = 4,
	max = 6,
	-- min = 1,
	-- max = 1,
	enemies = {
		{E.Mosquito, 3},
		-- {E.Larva, 3},
		-- {E.Fly, 1},

		-- {E.Larva, 4},
		-- {E.Fly, 3},
		-- {E.SpikedFly, 3},
		-- {E.SnailShelled, 3},
		-- {E.Slug, 2},
		-- {E.Grasshopper, 1},
		-- {E.MushroomAnt, 10},
	},
},

{ -- 2
	-- Slug intro
	min = 6,
	max = 8,
	enemies = {
		{E.Larva, 2},
		{E.Fly, 2},
		{E.Slug, 5},
	},
},

{ -- 3
	-- Grasshopper intro
	min = 4,
	max = 6,
	enemies = {
		{E.Slug, 2},
		{E.Grasshopper, 4},
	},
},


{ -- 4
	-- 
	min = 6,
	max = 8,
	enemies = {
		{E.Larva, 2},
		{E.Fly, 2},
		{E.Slug, 5},
		{E.Grasshopper, 1},
	},
},


{ -- 5
	-- Spider intro
	min = 4,
	max = 6,
	enemies = {
		{E.Larva, 2},
		{E.Spider, 4},
	},
},


{ -- 6
	-- 
	min = 6,
	max = 8,
	enemies = {
		{E.Larva, 3},
		{E.Slug, 2},
		{E.Fly, 3},
		{E.Spider, 4},
	},
},

{ -- 7
	min = 3,
	max = 5,
	enemies = {
		-- Shelled Snail intro
		{E.SnailShelled, 3},
		{E.Fly, 1},
	},
},

{ -- 8
	min = 6,
	max = 8,
	enemies = {
		-- 
		{E.Fly, 4},
		{E.Larva, 4},
		{E.SnailShelled, 3},
		{E.Spider, 3},
	},
},

{ -- 9
	-- SpikedFly intro
	min = 5,
	max = 7,
	enemies = {
		{E.Larva, 1},
		{E.Fly, 2},
		{E.SpikedFly, 4},
	},
},

{ -- 10
	-- Mushroom Ant intro
	min = 3,
	max = 4,
	enemies = {
		{E.MushroomAnt, 3},
	},
},


{ -- 11
	min = 6,
	max = 8,
	enemies = {
		{E.MushroomAnt, 3},
		{E.Fly, 1},
		{E.SpikedFly, 1},
		{E.Spider, 2},
	},
},

{ -- 12
	-- ALL
	min = 6,
	max = 8,
	enemies = {
		{E.Larva, 4},
		{E.Fly, 3},
		{E.SnailShelled, 3},
		{E.Slug, 2},
		{E.SpikedFly, 1},
		{E.Grasshopper, 1},
		{E.MushroomAnt, 1},
		{E.Spider, 1},
	},
},

-- unpack(duplicate_table({
	-- ALL BUT HARDER
	-- 13, 14, 15
{
	min = 8,
	max = 10,
	enemies = {
		{E.Larva, 4},
		{E.Fly, 3},
		{E.SnailShelled, 3},
		{E.Slug, 2},
		{E.SpikedFly, 1},
		-- {E.Grasshopper, 1},
		-- {E.MushroomAnt, 1},
		-- {E.Spider, 1},
	},
},{
	min = 10,
	max = 12,
	enemies = {
		-- {E.Larva, 4},
		-- {E.Fly, 3},
		-- {E.SnailShelled, 3},
		-- {E.Slug, 2},
		{E.SpikedFly, 1},
		{E.Grasshopper, 1},
		{E.MushroomAnt, 1},
		{E.Spider, 1},
	},
},{
	min = 12,
	max = 16,
	enemies = {
		{E.Larva, 4},
		{E.Fly, 3},
		{E.SnailShelled, 3},
		{E.Slug, 2},
		{E.SpikedFly, 1},
		{E.Grasshopper, 1},
		{E.MushroomAnt, 1},
		{E.Spider, 1},
	},
},
-- }, 4)),

-- Last wave
{ -- 16
	min = 1,
	max = 1,
	enemies = {
		{E.ButtonBigGlass, 1}
	}
}

}

local function sanity_check_waves()
	for i, wave in ipairs(waves) do
		assert((wave.min <= wave.max), "max > min for wave "..tostring(i))

		for j, enemy_pair in ipairs(wave.enemies) do
			local enemy_class = enemy_pair[1]
			local weight = enemy_pair[2]

			assert(enemy_class ~= nil, "enemy "..tostring(j).." for wave "..tostring(i).." doesn't exist")
			assert(type(weight) == "number", "weight for enemy "..tostring(j).." for wave "..tostring(i).." isn't a number")
			assert(weight >= 0, "weight for enemy "..tostring(j).." for wave "..tostring(i).." is negative")
		end
	end
end

sanity_check_waves()

return waves