require "scripts.util"
local Enemy = require "scripts.actor.enemy"
local sounds = require "data.sounds"
local images = require "data.images"
local Guns = require "data.guns"
local Timer = require "scripts.timer"
local PongBall = require "scripts.actor.enemies.pong_ball"

local FlyingDung = PongBall:inherit()

function FlyingDung:init(x, y, spawner)
    self:init_flying_dung(x, y, spawner)
end

function FlyingDung:init_flying_dung(x, y, spawner)
    self:init_pong_ball(x,y, images.dung_1, 16, 16)
    self.name = "flying_dung"
    self.spawner = spawner

    self.state = "ponging"
    self.invul = true
    self.invul_timer = Timer:new(1.0)
    self.invul_timer:start()

    self:init_pong(100)
    
    self.is_pushable = false
    self.is_bouncy_to_bullets = true
    self.destroy_bullet_on_impact = false
    self.is_stompable = true
    self.is_killed_on_stomp = false
end

function FlyingDung:update(dt)
    self:update_pong_ball(dt)

    if self.invul_timer:update(dt) then
        self.invul = false
    end

    if self.state == "targeting" then
        Particles:smoke(self.mid_x, self.mid_y, 3)
    end
end

function FlyingDung:draw()
    self:draw_pong_ball()
end

function FlyingDung:on_stomped(damager)
    self.state = "targeting"
    self.is_ponging = false

    if self.spawner then
        local a = atan2(self.spawner.mid_y - self.mid_y, self.spawner.mid_x - self.mid_x)
        self.pong_vx = 0
        self.pong_vy = 0
        self.vx = math.cos(a) * self.pong_speed * 3
        self.vy = math.sin(a) * self.pong_speed * 3
        game:screenshake(3) 
    end
end

function FlyingDung:after_collision(col, other)
    self:after_collision_pong_ball(col, other)

    if col.type ~= "cross" then
        if not self.is_ponging then 
            self:kill()
            -- self.is_ponging = true
            -- self.state = "ponging"
            -- self:init_pong()
        end
    end
    if col.other == self.spawner and not self.invul and self.state == "targeting" then
        if col.other.name == "dung_beetle" then
            col.other:on_hit_flying_dung(self)
        end
        game:screenshake(6)
    	game:frameskip(8)

        self:kill()
    end 
end

function FlyingDung:on_death()
end

return FlyingDung