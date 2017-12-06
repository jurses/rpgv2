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
	for i, v in ipairs(self.entityEB) do
		v:update()
	end
end

function p.checkCollision(x1, y1, w1, h1, x2, y2, w2, h2)
	return x1 < x2 + w2 and
			x2 < x1 + w1 and
			y1 < y2 + h2 and
			y2 < y1 + h1
end

function stg:charAttack(id)
	d1 = {}
	d1.x, d1.y = self.entityC[id]:getAttackCornerPos()
	x, y = self.entityC[id]:getPosition()
	d1.w, d1.h = self.entityC[id]:getAttackArea()
	d2 = {}
	for i, v in ipairs(self.entityC) do
		d2.x, d2.y = v:getCornerPos()
		d2.w, d2.h = v:getDimensions()
		if id ~= i and p.checkCollision(d1.x, d1.y, d1.w, d1.h, d2.x, d2.y, d2.w, d2.h) then
			v:hurt(x, y, self.entityC[id]:getForce())
		end
	end
end

function stg:collideEB(id, force)
	x1, y1 = self.entityEB[id]:getPosition()
	w1, h1 = self.entityEB[id]:getDimensions()
	xo, yo = self.entityC[self.entityEB[id]:getOwner()]:getPosition()
	-- Colisión con personajes
	for i, v in ipairs(self.entityC) do
		if self.entityEB[id]:getOwner() ~= i then
			x2, y2 = v:getCornerPos()
			w2, h2 = v:getDimensions()
			if p.checkCollision(x1, y1, w1, h1, x2, y2, w2, h2) then
				v:hurt(xo, yo,  force)
				if self.entityEB[id]:isEphimeral() then
					return
				end
			end
		end
	end
	--[[
	for i, v in ipairs(self.entityEB) do
		if v:getID() ~= id then
			x2, y2 = v:getPosition()
			w2, h2 = v:getDimensions()
			if p.checkCollision(x1, y1, w1, h1, x2, y2, w2, h2) then
				print("Choque con bola de energía")
				--table.remove(self.entityEB, id)
				--table.remove(self.entityEB, v:getID())
				return true
			end
		end
	end
	]]
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