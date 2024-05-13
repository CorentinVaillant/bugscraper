require "scripts.util"
local Class = require "scripts.meta.class"
local ElevatorDoor = require "scripts.level.elevator_door"
local Timer = require "scripts.timer"

local images = require "data.images"
local sounds = require "data.sounds"

local Elevator = Class:inherit()

function Elevator:init(level)
    self.level = level

	self.door = ElevatorDoor:new(self.level.door_rect.ax, self.level.door_rect.ay)
	self.door:close()

	self.floor_progress = 0.0
	self.door_animation = false
	self.has_switched_to_next_floor = false 

	self.door_animation_timer = Timer:new(1.0)

	self.clock_ang = pi
end

function Elevator:update(dt)
	self:update_door_animation(dt)
	
	if self.door_animation_timer:update(dt) then
		self:close_door()
	end
end

function Elevator:open_door(close_timer)
	self.door:open()
	sounds.elev_door_open.source:play()
	if close_timer then
		self.door_animation_timer:set_duration(close_timer)
		self.door_animation_timer:start()
	end
end

function Elevator:close_door()
	self.door:close()
	sounds.elev_door_close.source:play()
	self.door_animation_timer:stop()
	self.level:on_door_close()
end

function Elevator:update_door_animation(dt)
	self.door:update(dt)
	if self.floor_progress == 0 then return end
end

function Elevator:set_floor_progress(val)
	self.floor_progress = val
end

---------------------------------------------

<<<<<<< HEAD
function Elevator:draw(enemy_buffer)
=======
function Elevator:draw(enemy_buffer, wave_progress)
>>>>>>> main
	local x, y = self.level.door_rect.ax, self.level.door_rect.ay
	local w, h = self.level.door_rect.bx - self.level.door_rect.ax+1, self.level.door_rect.by - self.level.door_rect.ay+1
	rect_color(self.level.background.clear_color, "fill", x, y, w, h);

	-- Draw buffered enemies
	for i,e in pairs(enemy_buffer) do
		e:draw()
	end

	self:draw_cabin()
end


function Elevator:draw_cabin()
	local cabin_x, cabin_y = self.level.cabin_rect.ax, self.level.cabin_rect.ay 

	self.door:draw()

	-- Cabin background
	gfx.draw(images.cabin_bg, cabin_x, cabin_y)
	gfx.draw(images.cabin_bg_ambient_occlusion, cabin_x, cabin_y)
	
	self:draw_counter()
end

function Elevator:draw_counter()
	local cabin_x, cabin_y = self.level.cabin_rect.ax, self.level.cabin_rect.ay 

	-- Level counter clock thing
	local x1, y1 = cabin_x + 207.5, cabin_y + 89
	self.clock_ang = lerp(self.clock_ang, pi + clamp(self.level.floor / self.level.max_floor, 0, 1) * pi, 0.1)
	local a = self.clock_ang
	gfx.line(x1, y1, x1 + cos(a)*11, y1 + sin(a)*11)
	
	-- Level counter
	gfx.setFont(FONT_7SEG)
	print_color(COL_WHITE, string.sub("00000"..tostring(self.level.floor), -3, -1), 198+16*2, 97+16*2)
	gfx.setFont(FONT_REGULAR)
end


return Elevator