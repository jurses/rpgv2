local char = {}
local p = {}
local char_mt = {__index = char}
local energyBall = require("energyBall")
local charProp = require("charProp")

function char.new(w, x, y, r, bType, enableEntity)
	r = r or 16
	local s = charProp.obtCharProp() or {}
	s.body = love.physics.newBody(w, x, y, bType or "dynamic")
	s.shape = love.physics.newCircleShape(r)
	s.fixt = love.physics.newFixture(s.body, s.shape)
	s.fixt:setRestitution(0.9)
	if enableEntity == nil or enableEntity == true then
		s.enableEntity = true
	else
		s.enableEntity = false
	end
	print(s.color.r, s.color.g, s.color.b)
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
	if love.keyboard.isDown("z") then
		obj.stage:register(energyBall.new(obj.body:getX(), obj.body:getY(), obj.id, obj.direction))
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
		if obj.isNormal then
			obj.body:setLinearVelocity(0, 0)
			obj.body:setType("static")
		end
	end
end

function char:draw()
	if self.attack then
		love.graphics.setColor(self.colorAttack.r, self.colorAttack.g, self.colorAttack.b)
		love.graphics.rectangle("fill", self.body:getX() - self.attackArea.w / 2, self.body:getY() - self.attackArea.h / 2, self.attackArea.w, self.attackArea.h)
	end
	love.graphics.setColor(255, 5, 100, 122)
	love.graphics.rectangle("fill", self.body:getX() - self.dimensions.w/2, self.body:getY()- self.dimensions.h/2, self.dimensions.w, self.dimensions.h)
	love.graphics.setColor(self.color.r, self.color.g, self.color.b)
	love.graphics.circle("fill", self.body:getX(), self.body:getY(), self.shape:getRadius())
	love.graphics.setColor(self.colorAttack.r, self.colorAttack.g, self.colorAttack.b, 122)
	love.graphics.rectangle("fill", self.body:getX() - self.attackArea.w / 2, self.body:getY() - self.attackArea.h / 2, self.attackArea.w, self.attackArea.h)
end

function p.push(obj, x, y, force)
	vec = {x = obj.body:getX() - x, y = obj.body:getY() - y}
	mod = math.sqrt(math.pow(vec.x, 2) + math.pow(vec.y, 2))
	alpha = math.atan2(vec.y, vec.x)
	obj.body:setType("dynamic")
	obj.body:applyLinearImpulse(force * math.cos(alpha), force * math.sin(alpha))
end

function char:hurt(signal, x, y, force)
	if signal then
		self.start2Hurt = love.timer.getTime()
		self.color = {r = 255, g = 0, b = 0}
	end
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
	obj.isNormal = (love.timer.getTime() - obj.start2Hurt) > obj.tRecover
	if obj.isNormal then
		obj.color = {r = 23, g = 128, b = 98}
	end
end

function char:update()
	p.move(self)
	p.attack(self)
	p.status(self)
	p.shootEnergyBall(self)
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