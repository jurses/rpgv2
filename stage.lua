local stg = {}
local p = {}
local stg_mt = {__index = stg}

function stg.new(meter)
	local s = {}
	s.world = love.physics.newWorld()
	s.entityC = {}
	s.entityEB = {}
	s.vector = {x, y}
	love.physics.setMeter(meter or 16)
	setmetatable(s, stg_mt)
	return s
end

function stg:drawV(x, y, id1, id2)
	love.graphics.setColor(255, 255, 0)
	love.graphics.line(x, y, self.entityC[id1]:getX() - self.entityC[id2]:getX() + x, self.entityC[id1]:getY() - self.entityC[id2]:getY() + y)
end

function stg:register(entity)
	assert(entity)
	if entity:obtType() == "character" then
		table.insert(self.entityC, entity)
		self.entityC[#self.entityC]:getStg(self, #self.entityC)
	elseif entity:obtType() == "energyBall" then
		table.insert(self.entityEB, entity)
		self.entityEB[#self.entityEB]:getStg(self, #self.entityEB)
	end
end

function stg:update(dt)
	self.world:update(dt)
	for i, v in ipairs(self.entityC) do
		v:update()
	end
end

function p.isIn(s1, r, s2)
	pos1 = {x = s1:getBody():getX(), y = s1:getBody():getY()}
	radius1 = r * s1:getShape():getRadius()
	pos2 = {x = s2:getBody():getX(), y = s2:getBody():getY()}
	radius2 = s2:getShape():getRadius()
	return math.pow(pos2.x - pos1.x, 2) + math.pow(pos1.y - pos2.y, 2) <= math.pow(radius1 + radius2, 2)
end

function p.checkCollision(obj1, obj2)
	return obj1.x < obj2.x + obj2.w and
	obj2.x < obj1.x + obj1.x + obj1.w and
	obj1.y < obj2.y + obj2.h and
	obj2.y < obj1.y + obj1.h
end

function stg:charAttack(id)
	data1 = {}
	data1.x, data1.y = self.entityC[id]:getPosition()
	data1.w, data1.h = self.entityC[id]:getAttackArea()
	data2 = {}
	for i, v in ipairs(self.entityC) do
		data2.x, data2.y = v:getPosition()
		data2.w, data2.h = v:getAttackArea()
		if id ~= i and p.checkCollision(data1, data2) then
			v:hurt(true, data1.x, data1.y, self.entityC[id]:getForce())
		end
	end
end

--[[
function stg:charAttack(radius, id, force)
	for i, v in ipairs(self.entityC) do
		if id ~= i then
			if p.isIn(self.entityC[id]:giveChar(), radius, v:giveChar()) then
				v:hurt(true, self.entityC[id]:giveChar():getBody():getX(), self.entityC[id]:giveChar():getBody():getY(), force)
			end
		end
	end
end
]]

function stg:collideEB(id, force)
	for i, v in ipairs(self.entityC) do
		if v:obtOwner() ~= i then
			if p.isInCEB(self.entityEB[id]:getPosition(), self.entityEB[id]:getDimensions(), v:giveChar()) then
				v:hurt(true, self.entityEB[id]:getPosition(), force)
				table.remove(self.entityEB, id)
				return true
			end
		end
	end
	for i, v in ipairs(self.entityEB) do
		if v:getID() ~= i then
			if p.isInEB(self.entityEB[id]:getPosition(), self.entityEB[id]:getDimensions(), v:getPosition(), v:getDimensions()) then
				table.remove(self.entityEB, id)
				table.remove(self.entityEB, v:getID())
				return true
			end
		end
	end
end

function stg:obtWorld()
	return self.world
end

function stg:draw()
	for i, v in ipairs(self.entityC) do
		v:draw()
	end
	for i, v in ipairs(self.entityEB) do
		v:draw()
	end
end

return stg