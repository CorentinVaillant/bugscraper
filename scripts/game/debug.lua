require "scripts.util"
local Class = require "scripts.meta.class"
local Loot = require "scripts.actor.loot"

local Debug = Class:inherit()

function Debug:init(game)
    self.game = game

    self.is_reading_for_f1_action = false
    self.debug_menu = false
    self.colview_mode = false
    self.info_view = false

    self.notification_message = ""
    self.notification_timer = 0.0

    local func_damage = function(n)
        return function()
            local p = self.game.players[tonumber(n)]
            if p ~= nil then
                p:do_damage(1)
                p.iframes = 0.0
            end
        end
    end 
    local func_heal = function(n)
        return function()
            local p = self.game.players[tonumber(n)]
            if p ~= nil then
                p:do_damage(1)
                p.iframes = 0.0
            end
        end
    end 
    self.actions = {
        ["f2"] = {"toggle collision view mode", function()
            self.colview_mode = not self.colview_mode
        end},
        ["f3"] = {"view more info", function()
            self.info_view = not self.info_view
        end},
        ["1"] = {"damage P1", func_damage(1)},
        ["2"] = {"damage P2", func_damage(2)},
        ["3"] = {"damage P3", func_damage(3)},
        ["4"] = {"damage P4", func_damage(4)},
        ["5"] = {"heal P1", func_heal(1)},
        ["6"] = {"heal P2", func_heal(2)},
        ["7"] = {"heal P3", func_heal(3)},
        ["8"] = {"heal P4", func_heal(4)},
        ["q"] = {"previous floor",function()
            self.game.floor = self.game.floor - 1
        end},
        ["w"] = {"next floor", function()
            self.game.floor = self.game.floor + 1
        end},
        
        ["e"] = {"kill all enemies", function()
            for k,e in pairs(self.game.actors) do
                if e.is_enemy then
                    e:kill()
                end
            end
        end},
        
        ["g"] = {"next gun for P1", function()
            local p = self.game.players[1]
            if p then
                p:next_gun()
            end
        end},
        ["l"] = {"spawn random loot", function()
            local loot, parms = random_weighted({
                {Loot.Life, 3, loot_type="life", value=1},
		        {Loot.Gun, 3, loot_type="gun"},
            })
            if not loot then return end
            
            local x, y = CANVAS_WIDTH/2, CANVAS_HEIGHT/2
            local instance
            local vx = random_neighbor(300)
            local vy = random_range(-200, -500)
            local loot_type = parms.loot_type
            if loot_type == "ammo" or loot_type == "life" or loot_type == "gun" then
                instance = loot:new(x, y, parms.value, vx, vy)
            end 

            game:new_actor(instance)
        end},
    }

    self.action_keys = {}
    for k, v in pairs(self.actions) do
        table.insert(self.action_keys, k)
    end
    table.sort(self.action_keys)
end

function Debug:update(dt)
	self.notification_timer = math.max(self.notification_timer - dt, 0.0)
end

function Debug:debug_action(key, scancode, isrepeat)
	local action = self.actions[scancode]
    if action then
        action[2]()
    else
        self:new_notification("Action not recognized")
    end
end

function Debug:new_notification(msg)
    self.notification_message = msg
    self.notification_timer = 5.0
end

function Debug:keypressed(key, scancode, isrepeat)
    if isrepeat then return end

    if scancode == "f1"then
        self.is_reading_for_f1_action = true
    else 
        if love.keyboard.isScancodeDown("f1") then
            self:debug_action(key, scancode, isrepeat)
            self.is_reading_for_f1_action = false
            return
        end
    end
end

function Debug:keyreleased(key, scancode, isrepeat)
    if scancode == "f1" and self.is_reading_for_f1_action then
        self.debug_menu = not self.debug_menu
        self.is_reading_for_f1_action = false
    end
end

function Debug:gamepadpressed(joystick, buttoncode)
end

function Debug:gamepadreleased(joystick, buttoncode)
end    

function Debug:gamepadaxis(joystick, axis, value)
end

function Debug:draw()
    if self.info_view then
        self:draw_info_view()
    end
    if self.debug_menu then
        self:draw_debug_menu()
    end
    if self.notification_timer > 0.0 then
        print_outline(nil, nil, self.notification_message, self.game.cam_x, self.game.cam_y)
    end
end

function Debug:draw_debug_menu()
    local x = self.game.cam_x 
    local y = self.game.cam_y 
    for i, button in pairs(self.action_keys) do
        local action = self.actions[button]
        local text = concat("[", button, "]: ", action[1])
        print_outline(nil, nil, text, x, y)
        y = y + 16
    end
end

function Debug:draw_info_view()
	gfx.print(concat("FPS: ",love.timer.getFPS(), " / frmRpeat: ",self.game.frame_repeat, " / frame: ",frame), 0, 0)
	
	local players_str = "players: "
	for k, player in pairs(self.game.players) do
		players_str = concat(players_str, "{", k, ":", player.n, "}, ")
	end

	local users_str = "users: "	
	for k, player in pairs(Input.users) do
		users_str = concat(users_str, "{", k, ":", player.n, "}, ")
	end
	
	local joystick_user_str = "joysticks_to_users: "	
	for joy, user in pairs(Input.joystick_to_user_map) do
		joystick_user_str = concat(joystick_user_str, "{", string.sub(joy:getName(),1,4), "... ", ":", user.n, "}, ")
	end
	
	local joystick_str = "joysticks: "	
	for _, joy in pairs(love.joystick.getJoysticks()) do
		joystick_str = concat(joystick_str, "{", string.sub(joy:getName(),1,4), "...}, ")
	end
	
	local wave_resp_str = "waves_until_respawn "	
	for i = 1, MAX_NUMBER_OF_PLAYERS do
		wave_resp_str = concat(wave_resp_str, "{", i, ":", self.game.waves_until_respawn[i], "}, ")
	end

	
	-- Print debug info
	local txt_h = get_text_height(" ")
	local txts = {
		concat("FPS: ",love.timer.getFPS()),
		concat("LÖVE version: ", string.format("%d.%d.%d - %s", love.getVersion())),
		concat("n° of active source: ", love.audio.getActiveSourceCount()),
		concat("n° of actors: ", #self.game.actors, " / ", self.game.actor_limit),
		concat("n° of enemies: ", self.game.enemy_count),
		concat("n° collision items: ", Collision.world:countItems()),
		concat("windowed_w: ", Options:get("windowed_width")),
		concat("windowed_h: ", Options:get("windowed_height")),
		concat("real_wave_n ", self.game.debug2),
		concat("bg_color_index ", self.game.debug3),
		concat("number_of_alive_players ", self.game:get_number_of_alive_players()),
		players_str,
		users_str,
		joystick_user_str,
		joystick_str,
		wave_resp_str, 
		"",
	}

	for i=1, #txts do  print_label(txts[i], self.game.cam_x, self.game.cam_y+txt_h*i) end

	for _, e in pairs(self.game.actors) do
		love.graphics.circle("fill", e.x, e.y, 1)
	end

	self.game.world_generator:draw()
	draw_log()
end

function Debug:draw_colview()
	local items, len = Collision.world:getItems()
	for i,it in pairs(items) do
		local x,y,w,h = Collision.world:getRect(it)
		rect_color({0,1,0,.2},"fill", x, y, w, h)
		rect_color({0,1,0,.5},"line", x, y, w, h)
	end
end

return Debug