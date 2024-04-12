require "scripts.util"
local Upgrade = require "scripts.upgrade.upgrade"
local images= require "data.images"
local EffectSlowness = require "scripts.effect.effect_slowness"

local UpgradeTea = Upgrade:inherit()

function UpgradeTea:init()
    self:init_upgrade()
    self.name = "upgrade_tea"
    self.sprite = images.upgrade_tea

    self.title = "GREEN TEA"
    self.description = "+2 temporary ❤"
    self.color = COL_MID_GREEN
end

function UpgradeTea:update(dt)
    self:update_upgrade(dt)
end

function UpgradeTea:on_apply(player)
    player:add_temporary_life(2)

    Particles:smoke(player.mid_x, player.mid_y, 8, COL_LIGHT_GREEN)
end

function UpgradeTea:on_finish(player)
end



return UpgradeTea