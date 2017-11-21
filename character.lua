local char = {}
local p = {}
local char_mt = {__index = char}

function char.new(w, x, y, r, bType, enableEntity)
	local s = {}
	s.body = love.physics.newBody(w, x, y, bType or "dynamic")
	s.moving = false
	s.shape = love.physics.newCircleShape(r or 16)
	s.attack = false
	s.isHurt = false
	s.tRecover = 0.7
	s.tStart = love.timer.getTime()
	if enableEntity == nil or enableEntity == true then
		s.enableEntity = true
	else
		s.enableEntity = false
	end
	s.fixt = love.physics.newFixture(s.body, s.shape)
	s.fixt:setRestitution(0.9)
	s.stage = nil
	s.id = nil
	s.color = {r = 23, g = 128, b = 98}
	s.colorAttack = {r = 228, g = 135, b = 49}
	s.force = 500
	setmetatable(s, char_mt)
	return s
end

function char:giveChar()
	return self.fixt
end

function char:getStg(stage, id)
	self.stage = stage
	self.id = id
end

function p.move(obj)
	if obj.enableEntity and (love.keyboard.isDown("w") or
	love.keyboard.isDown("a") or
	love.keyboard.isDown("s") or
	love.keyboard.isDown("d")) then
		if love.keyboard.isDown("w") then
			obj.body:setLinearVelocity(0, -200)
			obj.moving = true
		elseif love.keyboard.isDown("a") then
			obj.body:setLinearVelocity(-200, 0)
			obj.moving = true
		elseif love.keyboard.isDown("s") then
			obj.body:setLinearVelocity(0, 200)
			obj.moving = true
		elseif love.keyboard.isDown("d") then
			obj.body:setLinearVelocity(200, 0)
			obj.moving = true
		end
		if love.keyboard.isDown("w") and love.keyboard.isDown("a") then
			obj.body:setLinearVelocity(-200 * math.cos(45), -200 * math.sin(45))
		elseif love.keyboard.isDown("w") and love.keyboard.isDown("d") then
			obj.body:setLinearVelocity(200 * math.cos(45), -200 * math.sin(45))
		elseif love.keyboard.isDown("s") and love.keyboard.isDown("a") then
			obj.body:setLinearVelocity(-200 * math.cos(45), 200 * math.sin(45))
		elseif love.keyboard.isDown("s") and love.keyboard.isDown("d") then
			obj.body:setLinearVelocity(200 * math.cos(45), 200 * math.sin(45))
		end
	elseif obj.moving then
			obj.body:setLinearVelocity(0, 0)
			obj.moving = false
	end
end

function char:draw()
	if self.attack then
		love.graphics.setColor(self.colorAttack.r, self.colorAttack.g, self.colorAttack.b)
		love.graphics.circle("fill", self.body:getX(), self.body:getY(), self.shape:getRadius() * 1.4)
	end
	love.graphics.setColor(self.color.r, self.color.g, self.color.b)
	love.graphics.circle("fill", self.body:getX(), self.body:getY(), self.shape:getRadius())
end

function p.push(obj, x, y)
	vec = {x = obj.body:getX() - x, y = obj.body:getY() - y}
	mod = math.sqrt(math.pow(vec.x, 2) + math.pow(vec.y, 2))
	alpha = math.atan2(vec.y, vec.x)
	print("alpha = " .. 180 * alpha / math.pi,  alpha)
	-- pi r -- 90
	-- x r -- y rad
	-- y = x * 90/pi
	--obj.body:applyForce(obj.force * math.cos(alpha), obj.force * math.sin(alpha))
	obj.body:applyLinearImpulse(obj.force * math.cos(alpha), obj.force * math.sin(alpha))
end

function char:hurt(signal, x, y)
	if signal then
		self.tStart = love.timer.getTime()
		self.color = {r = 255, g = 0, b = 0}
	end
	p.push(self, x, y)
end

function p.attack(obj)
	if obj.enableEntity then
		obj.attack = love.keyboard.isDown("space")
	end
	if obj.attack then
		obj.stage:charAttack(1.4, obj.id)
	end
end

function char:update()
	p.move(self)
	p.attack(self)
	self.isHurt = (love.timer.getTime() - self.tStart) > self.tRecover
	if self.isHurt then
		self.color = {r = 23, g = 128, b = 98}
	end
	-- print(self.body:getX(), self.body:getY())
end

function char:getX()
	return self.body:getX()
end

function char:getY()
	return self.body:getY()
end

function char:getID()
	return self.id
end

return char