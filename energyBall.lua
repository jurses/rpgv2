local energyBall = {}
local p = {}
local energyBall_mt = {__index = energyBall}

function energyBall.new(x, y, id, direction)
    local s = {}
    s.id = nil
    s.dim = {w = 5, h = 5}
    s.pos = {x = x, y = y}
    s.stage = nil
    s.owner = id
    s.dir = direction
    s.speed = 100
    s.force
    s.type = "energyBall"
    setmetatable(s, energyBall_mt)
    return s
end

function energyBall:obtType()
    return self.type
end

function energyBall:getStg(stage, id)
end

function p.checkCollide(obj)

end

function energyBall:getID()
    return self.id
end

function energyBall:draw()
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
end

function energyBall:update()
    p.forward(self)
    self.stage:collideEB(self.id, self.force)
end

function energyBall:getDimensions()
    return self.dim.w, self.dim.h
end

function energyBall:getPosition()
    return self.pos.x, self.pos.y
end

function energyBall:obtOwner()
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