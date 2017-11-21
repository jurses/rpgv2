local stg = {}
local p = {}
local stg_mt = {__index = stg}

function stg.new(meter)
	local s = {}
	s.world = love.physics.newWorld()
	s.entity = {}
	s.vector = {x, y}
	love.physics.setMeter(meter or 16)
	setmetatable(s, stg_mt)
	return s
end

function stg:drawV(x, y, id1, id2)
	love.graphics.setColor(255, 255, 0)
	love.graphics.line(x, y, self.entity[id1]:getX() - self.entity[id2]:getX() + x, self.entity[id1]:getY() - self.entity[id2]:getY() + y)
end

-- Irá guardando los "fixtures"
function stg:register(entity)
	assert(entity)
	table.insert(self.entity, entity)
	entity:getStg(self, #self.entity)
end

function stg:update(dt)
	self.world:update(dt)
	for i, v in ipairs(self.entity) do
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

function stg:charAttack(radius, id)
	for i, v in ipairs(self.entity) do
		if id ~= i then
			if p.isIn(self.entity[id]:giveChar(), radius, v:giveChar()) then
				v:hurt(true, self.entity[id]:giveChar():getBody():getX(), self.entity[id]:giveChar():getBody():getY())
			end
		end
	end
end

function stg:obtWorld()
	return self.world
end

function stg:draw()
end

return stg