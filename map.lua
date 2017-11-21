local map = {}
local p = {}
local map_mt = {__index = map}

function p.obtFixtT(layers, world)
	auxBody = nil
	auxShape = nil
	fixT = {}
	for i, v in ipairs(layers) do
		if v.type == "objectgroup" then
			for j, w in ipairs(v.objects) do
				auxBody = love.physics.newBody(world, (w.x + w.width/2), (w.y + w.height/2), "static")
				auxShape = love.physics.newRectangleShape(w.width, w.height)
				table.insert(fixT, love.physics.newFixture(auxBody, auxShape))
			end
		end
	end
	return fixT
end

function p.configureCanvas(canvas, fixture_t)
	love.graphics.setCanvas(canvas)
	love.graphics.clear()
	love.graphics.setColor(255, 255, 255)
	for i, v in ipairs(fixture_t) do
		love.graphics.polygon("fill", v:getBody():getWorldPoints(v:getShape():getPoints()))
	end
	love.graphics.setCanvas()
end

function map.new(mapa, world)
	local s = {}
	s.canvas = love.graphics.newCanvas(mapa.width * mapa.tilewidth, mapa.height * mapa.tileheight)
	s.fixtT = p.obtFixtT(mapa.layers, world)
	p.configureCanvas(s.canvas, s.fixtT)
	setmetatable(s, map_mt)
	return s
end

function map:draw()
	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(self.canvas)
end

return map