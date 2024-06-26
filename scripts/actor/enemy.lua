require "scripts.util"
local Class = require "scripts.meta.class"
local Actor = require "scripts.actor.actor"
local Loot = require "scripts.actor.loot"
local images = require "data.images"
local sounds = require "data.sounds"

local Enemy = Actor:inherit()

function Enemy:init_enemy(x,y, img, w,h)
	-- TODO: abstract enemies and players into a single "being" class
	-- "Being" means players, enemies, etc, but not bullets, etc
	-- They have life, can take or deal damage, and inherit Actor:
	-- so they have velocity and collision. 
	w,h = w or 12, h or 12
	self:init_actor(x, y, w, h, img or images.duck)
	self.name = "enemy"
	self.counts_as_enemy = true -- don't count in the enemy counter
	self.is_being = true 
	self.is_enemy = true
	self.is_flying = false
	self.is_active = true
	self.follow_player = true

	self.destroy_bullet_on_impact = true
	self.is_bouncy_to_bullets = false
	self.is_immune_to_bullets = false

	self.harmless_timer = 0

	self.kill_when_negative_life = true
	self.max_life = 10
	self.life = self.max_life
	self.color = COL_BLUE
	self.speed = 20
	self.speed_x = self.speed
	self.speed_y = 0

	self.loot = {
		{nil, 160},
		-- {Loot.Ammo, 0, loot_type="ammo", value=20},
		{Loot.Life, 6, loot_type="life", value=1},
		{Loot.Gun, 4, loot_type="gun"},
	}

	self.is_stompable = true
	self.is_killed_on_stomp = true
	self.do_stomp_animation = true
	self.stomp_height = self.h/2

	self.is_pushable = true
	self.is_knockbackable = true -- Multiplicator when knockback is applied to

	self.damage = 1
	self.knockback = 1200
	self.self_knockback_mult = 1 -- Basically weight (?)

	self.damaged_flash_timer = 0
	self.damaged_flash_max = 0.07

	self.squash = 1
	self.squash_target = 1
	
	self.play_sfx = true
	self.sound_damage = "enemy_damage"
	self.sound_death = "enemy_death_1"
	self.sound_stomp = "enemy_death_1"

	self.target = nil

	self.harmless_timer = 0.0

	self.do_vx_flipping = true
	self.do_killed_smoke = true
	-- self.sound_stomp = {"enemy_stomp_2", "enemy_stomp_3"}
	--{"crush_bug_1", "crush_bug_2", "crush_bug_3", "crush_bug_4"}
end

function Enemy:update_enemy(dt)
	-- if not self.is_active then    return    end
	self:update_actor(dt)
	
	self:follow_nearest_player(dt)
	self.harmless_timer = max(self.harmless_timer - dt, 0)
	self.damaged_flash_timer = max(self.damaged_flash_timer - dt, 0)
	self.spr:set_flip_x(ternary(self.do_vx_flipping, self.vx < 0, false))
end
function Enemy:update(dt)
	self:update_enemy(dt)
end

function Enemy:get_nearest_player()
	local shortest_dist = math.huge
	local nearest_player 
	for _, ply in pairs(game.players) do
		local dist = distsqr(self.x, self.y, ply.x, ply.y)
		if dist < shortest_dist then
			shortest_dist = dist
			nearest_player = ply
		end
	end
	return nearest_player
end

function Enemy:follow_nearest_player(dt)
	self.target = nil
	if not self.follow_player then
		return
	end

	-- Find closest player
	local nearest_player = self:get_nearest_player()
	if not nearest_player then
		return
	end
	self.target = nearest_player
	
	self.speed_x = self.speed_x or self.speed
	if self.is_flying then    self.speed_y = self.speed_y or self.speed 
	else                      self.speed_y = self.speed_y or 0    end 

	self.vx = self.vx + sign0(nearest_player.x - self.x) * self.speed_x
	self.vy = self.vy + sign0(nearest_player.y - self.y) * self.speed_y
end

function Enemy:draw_enemy()
	local f = (self.damaged_flash_timer > 0) and draw_white
	self:draw_actor(f)

	if game.debug.info_view then
		gfx.draw(images.heart, self.x-7 -2+16, self.y-16)
		print_outline(COL_WHITE, COL_DARK_BLUE, self.life, self.x+16, self.y-16-2)
	end
end

function Enemy:draw()
	self:draw_enemy()
end

function Enemy:on_collision(col, other)
	if self.is_removed then return end

	-- If hit wall, reverse x vel (why is this here?????) TODO: wtf
	if col.type ~= "cross" and col.normal.y == 0 then 
		self.vx = -self.vx
	end

	-- Player
	if col.other.is_player then
		local player = col.other
		
		-- Being stomped
		local epsilon = 0.01
	
		-- if player.vy > epsilon and self.is_stompable then
		local feet_y = player.y + player.h

		local is_on_head      = false --(feet_y <= self.y + self.h/2)
		local is_falling_down = (player.vy > 0.0001)-- and (feet_y <= self.y + self.h*0.75)
		local recently_landed = (0 < player.frames_since_land) and (player.frames_since_land <= 4) --7
		if self.is_stompable and (is_on_head or is_falling_down or recently_landed) then
			player.vy = 0
			player:on_stomp(self)
			if self.do_stomp_animation then
				local ox, oy = self.spr:get_total_centered_offset_position(self.x, self.y, self.w, self.h)
				Particles:stomped_enemy(self.mid_x, self.y+self.h, self.spr.image)
			end
			self:on_stomped(player)
			if self.is_killed_on_stomp then
				self:kill(player, "stomped")
			end

		else
			-- Damage player
			if self.harmless_timer <= 0 then
				player:do_damage(self.damage, self)
				self:on_damage_player(player, self.damage)
			end
		end
		
	end
	
	-- Being collider push force
	if col.other.is_being and self.is_pushable and other.is_pushable then
		self:do_knockback_from(10, col.other)
		col.other:do_knockback_from(10, self)
	end

	self:after_collision(col, col.other)
end

function Enemy:on_damage_player(player, damage)
end

function Enemy:after_collision(col, other)  end

function Enemy:do_damage(n, damager)
	self.damaged_flash_timer = self.damaged_flash_max
	
	if self.play_sfx then   Audio:play_var(self.sound_damage, 0.3, 1.1)   end
	self.life = self.life - n
	self:on_damage(n, self.life + n)

	if self.life <= 0 then
		if self.kill_when_negative_life then
			self:kill(damager)
		end 
		self:on_negative_life()
	end
end

function Enemy:on_negative_life()
end

function Enemy:on_damage()

end

function Enemy:on_stomped(damager)

end

function Enemy:kill(damager, reason)
	if self.is_removed then
		print(concat("/!\\:", self.name, "(", self, ") was killed while destroyed"))
		return
	end
	self.death_reason = reason or ""

	if self.do_killed_smoke then
		Particles:smoke(self.mid_x, self.mid_y)
	end
	if self.play_sfx then
		if reason == "stomped" then
			Audio:play_var(self.sound_stomp, 0.3, 1.1)
		else
			Audio:play_var(self.sound_death, 0.3, 1.1)
		end
	end

	game:on_kill(self)
	self:remove()
	
	self:drop_loot()
	self:on_death(damager, reason)
end

function Enemy:drop_loot()
	local loot, parms = random_weighted(self.loot)
	if not loot then            return    end
	
	local instance
	local vx = random_neighbor(300)
	local vy = random_range(-200, -500)
	local loot_type = parms.loot_type
	if loot_type == "ammo" or loot_type == "life" or loot_type == "gun" then
		instance = loot:new(self.mid_x, self.mid_y, parms.value, vx, vy)
	end 

	game:new_actor(instance)
end

function Enemy:on_death(damager, reason)
	
end

function Enemy:on_hit_bullet(bul, col)
	if self.is_immune_to_bullets then
		return false
	end
	self:do_damage(bul.damage, bul)
	
	if self.is_knockbackable then
		local ang = atan2(bul.vy, bul.vx)
		self.vx = self.vx + cos(ang) * bul.knockback * self.self_knockback_mult
		self.vy = self.vy + sin(ang) * bul.knockback * self.self_knockback_mult
	end
	return true
end

return Enemy