local energyBall = {}
local p = {}
local energyBall_mt = {__index = energyBall}

function energyBall.new(x, y, id, direction, stage)
    local s = {}
    s.id = nil
    s.dim = {w = 5, h = 5}
    s.pos = {x = x - s.dim.w/2, y = y - s.dim.h/2}
    s.stage = stage
    s.owner = id
    s.dir = direction
    s.dead = false
    s.speed = 50
    s.force = 75
    s.type = "energyBall"
    s.ephimeral = true
    setmetatable(s, energyBall_mt)
    return s
end

function energyBall:obtType()
    return self.type
end

function energyBall:getStg(stage, id)
    self.stage = stage
    self.id = id
end

function energyBall:getID()
    return self.id
end

function energyBall:isEphimeral()
    return self.ephimeral
end

function energyBall:draw()
    love.graphics.setColor(255, 255, 0)
    love.graphics.rectangle("fill", self.pos.x, self.pos.y, self.dim.w, self.dim.h)
end

function energyBall:update()
    p.forward(self)
    self.dead = self.stage:collideEB(self.pos.x, self.pos.y, self.dim.w, self.dim.h, self.owner, self.force) -- necesito solo una función que me devuelva si hay colisión o no
end

function energyBall:getDimensions()
    return self.dim.w, self.dim.h
end

function energyBall:isDead()
    return self.dead
end

function energyBall:getPosition()
    return self.pos.x, self.pos.y
end

function energyBall:getX()
    return self.pos.x + self.dim.w/2
end

function energyBall:getY()
    return self.pos.y + self.dim.h/2
end

function energyBall:getOwner()
    return self.owner
end

function p.forward(obj)
    dt = love.timer.getDelta()
    if obj.dir == "up" then
        obj.pos.y = obj.pos.y - obj.speed * dt
    elseif obj.dir == "left" then
        obj.pos.x = obj.pos.x - obj.speed * dt
    elseif obj.dir == "down" then
        obj.pos.y = obj.pos.y + obj.speed * dt
    elseif obj.dir == "right" then
        obj.pos.x = obj.pos.x + obj.speed * dt
    elseif obj.dir == "upleft" then
        obj.pos.y = obj.pos.y - obj.speed * math.cos(45) * dt
        obj.pos.x = obj.pos.x - obj.speed * math.cos(45) * dt
    elseif obj.dir == "upright" then
        obj.pos.y = obj.pos.y - obj.speed * math.cos(45) * dt
        obj.pos.x = obj.pos.x + obj.speed * math.cos(45) * dt
    elseif obj.dir == "downleft" then
        obj.pos.y = obj.pos.y + obj.speed * math.cos(45) * dt
        obj.pos.x = obj.pos.x - obj.speed * math.cos(45) * dt
    elseif obj.dir == "downright" then
        obj.pos.y = obj.pos.y + obj.speed * math.cos(45) * dt
        obj.pos.x = obj.pos.x + obj.speed * math.cos(45) * dt
    end
end

return energyBall