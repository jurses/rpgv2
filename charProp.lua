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
        isNormal = true,
        tRecover = 0.7,
        start2Hurt = love.timer.getTime(),
        enableEntity = true,
        stage = nil,
        id = nil,
        color = {r = 23, g = 128, b = 98},
        colorAttack = {r = 228, g = 135, b = 49},
        force = 500,
        unique = true,
        energyBall = nil
    }
end
return charProp