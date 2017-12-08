local energyBall = require("energyBall")
local charProp = require("charProp")
local quantum = require("quantum")

local char = {}
local p = {}
local char_mt = {__index = char}


function char.new(w, x, y, r, bType, enableEntity)
	r = r or 16
	local s = charProp.obtCharProp() or {}
	s.body = love.physics.newBody(w, x, y, bType or "dynamic")
	s.shape = love.physics.newCircleShape(r)
	s.fixt = love.physics.newFixture(s.body, s.shape)
	s.last = {x, y}
	s.fixt:setRestitution(0.9)
	s.hurtTime = quantum.new(0.7)

	if enableEntity == nil or enableEntity == true then
		s.enableEntity = true
	else
		s.enableEntity = false
	end
	s.color[1] = s.colorNeutral[1]
	s.color[2] = s.colorNeutral[2]
	s.color[3] = s.colorNeutral[3]
	setmetatable(s, char_mt)
	return s
end

function char:obtType()
	return self.type
end

function char:giveChar()
	return self.fixt
end

function char:getStg(stage, id)
	self.stage = stage
	self.id = id
end

function p.shootEnergyBall(obj)
	if love.keyboard.isDown("z") and obj.shotAllow then
		table.insert(obj.projectil, energyBall.new(obj.body:getX(), obj.body:getY(), obj.id, obj.direction, obj.stage))
		obj.shotAllow = false
	end
end

function p.move(obj)
	if obj.enableEntity then
		if love.keyboard.isDown("w") then
			obj.moving = true
			obj.body:setType("dynamic")
			obj.body:setLinearVelocity(0, -200)
			obj.direction = "up"
		elseif love.keyboard.isDown("a") then
			obj.moving = true
			obj.body:setType("dynamic")
			obj.body:setLinearVelocity(-200, 0)
			obj.direction = "left"
		elseif love.keyboard.isDown("s") then
			obj.moving = true
			obj.body:setType("dynamic")
			obj.body:setLinearVelocity(0, 200)
			obj.direction = "down"
		elseif love.keyboard.isDown("d") then
			obj.moving = true
			obj.body:setType("dynamic")
			obj.body:setLinearVelocity(200, 0)
			obj.direction = "right"
		else
			obj.moving = false
		end
		if love.keyboard.isDown("w") and love.keyboard.isDown("a") then
			obj.moving = true
			obj.body:setType("dynamic")
			obj.body:setLinearVelocity(-200 * math.cos(45), -200 * math.sin(45))
			obj.direction = "upleft"
		elseif love.keyboard.isDown("w") and love.keyboard.isDown("d") then
			obj.moving = true
			obj.body:setType("dynamic")
			obj.body:setLinearVelocity(200 * math.cos(45), -200 * math.sin(45))
			obj.direction = "upright"
		elseif love.keyboard.isDown("s") and love.keyboard.isDown("a") then
			obj.moving = true
			obj.body:setType("dynamic")
			obj.body:setLinearVelocity(-200 * math.cos(45), 200 * math.sin(45))
			obj.direction = "downleft"
		elseif love.keyboard.isDown("s") and love.keyboard.isDown("d") then
			obj.moving = true
			obj.body:setType("dynamic")
			obj.body:setLinearVelocity(200 * math.cos(45), 200 * math.sin(45))
			obj.direction = "downright"
		end
	end
	if not obj.moving then
		if obj.cStatus == "neutral" then
			obj.body:setLinearVelocity(0, 0)
			obj.body:setType("static")
		end
	end
end

function char:draw()
	--[[
	-- rango de ataque
	love.graphics.setColor(self.colorAttack, 122)
	love.graphics.rectangle("fill", self.body:getX() - self.attackArea.w / 2, self.body:getY() - self.attackArea.h / 2, self.attackArea.w, self.attackArea.h)
	]]

	if self.attack then
		-- hitbox del rango de ataque que se activa
		love.graphics.setColor(self.colorAttack)
		love.graphics.rectangle("fill", self.body:getX() - self.attackArea.w / 2, self.body:getY() - self.attackArea.h / 2, self.attackArea.w, self.attackArea.h)
	end
	-- hitbox del personaje
	love.graphics.setColor(self.colorHurt)
	love.graphics.rectangle("fill", self.body:getX() - self.dimensions.w/2, self.body:getY()- self.dimensions.h/2, self.dimensions.w, self.dimensions.h)

	-- personaje
	love.graphics.setColor(self.color)
	love.graphics.circle("fill", self.body:getX(), self.body:getY(), self.shape:getRadius())

	if self.cStatus == "hurt" then
		love.graphics.line( self:getX(), self:getY(), self.last.x, self.last.y)
	end

	for i, v in ipairs(self.projectil) do
		v:draw()
	end
end


-- Función de empuje del objeto
function p.push(obj, x, y, force)
	obj.last.x = x
	obj.last.y = y
	vec = {x = obj.body:getX() - x, y = obj.body:getY() - y}
	mod = math.sqrt(math.pow(vec.x, 2) + math.pow(vec.y, 2))
	alpha = math.atan2(vec.y, vec.x)
	obj.body:setType("dynamic")
	obj.body:applyLinearImpulse(force * math.cos(alpha), force * math.sin(alpha))
end

function char:hurt(x, y, force)
	self.hurtTime:refresh(0.7)
	self.cStatus = "hurt"
	self.color[1] = self.colorHurt[1]
	self.color[2] = self.colorHurt[2]
	self.color[3] = self.colorHurt[3]
	p.push(self, x, y, force)
end

function char:getForce()
	return self.force
end

function p.attack(obj)
	if obj.enableEntity then
		obj.attack = love.keyboard.isDown("space")
	end
	if obj.attack then
		obj.stage:charAttack(obj.id)
	end
end

function p.status(obj)
	-- Sigue herido
	if obj.cStatus == "hurt" then
		obj.hurtTime:update()
	end

	if not obj.shotAllow and not love.keyboard.isDown("z") then
		obj.shotAllow = true
	end
	-- Está herido pero su tiempo de herido ya pasó -> lo ponemos neutral
	if obj.cStatus == "hurt" and obj.hurtTime:stateSignal() then
		obj.color[1] = obj.colorNeutral[1]
		obj.color[2] = obj.colorNeutral[2]
		obj.color[3] = obj.colorNeutral[3]
		obj.cStatus = "neutral"
	end
end

function char:update()
	p.move(self)
	p.attack(self)
	p.status(self)
	p.shootEnergyBall(self)
	for i, v in ipairs(self.projectil) do
		v:update()
	end
	for i, v in ipairs(self.projectil) do
		if v:isDead() then
			table.remove(self.projectil, i)
		end
	end
end

function char:getPosition()
	return self.body:getWorldCenter()
end

function char:getCornerPos()
	return self.body:getX() - self.dimensions.w/2, self.body:getY() - self.dimensions.h/2
end

function char:getAttackArea()
	return self.attackArea.w, self.attackArea.h
end

function char:getAttackCornerPos()
	return self.body:getX() - self.attackArea.w/2, self.body:getY() - self.attackArea.h/2
end

function char:getX()
	return self.body:getX()
end

function char:getY()
	return self.body:getY()
end

function char:getDimensions()
	return self.dimensions.w, self.dimensions.h
end

function char:getID()
	return self.id
end

return char