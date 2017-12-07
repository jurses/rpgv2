charProp = {}
function charProp.obtCharProp()
    r = r or 16
    return{
        type = "character",
        direction = "down",
        moving = false,
        attack = false,
        dimensions = {w = 2 * r, h = 2 * r},
        attackArea = {w = r * 3 or 24, h = r * 3 or 24},
        cStatus = "neutral",
        tRecover = 0.7,
        start2Hurt = love.timer.getTime(),
        hurtTime,
        shotAllow = true,
        rateFire = 5,
        enableEntity = true,
        stage = nil,
        id = nil,
        color = {},   -- color actual
        colorNeutral = {23, 128, 98},  -- neutral
        colorAttack = {228, 135, 49},   -- attack
        colorHurt = {255, 0, 0},    -- hurted
        force = 500,
        unique = true,
        energyBall = nil,
        projectil = {}
    }
end
return charProp