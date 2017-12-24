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

function p.obtSpriteBatchT(tilesets, layers)
	auxSpriteBatch = {}
	auxTileSet = {}
	for i, v in ipairs(tilesets) do
		table.insert(auxTileSet, love.graphics.newImage(v.image))
	end
	for i, v in ipairs(layers) do
		if type == "tilelayer" then
			table.insert(auxSpriteBatch, love.graphics.newSpriteBatch())
		end
	end
end

function p.configureCanvas(obsCanvas, fixture_t)
	love.graphics.setCanvas(obsCanvas)
	love.graphics.clear()
	love.graphics.setColor(255, 255, 255)
	for i, v in ipairs(fixture_t) do
		love.graphics.polygon("fill", v:getBody():getWorldPoints(v:getShape():getPoints()))
	end
	love.graphics.setCanvas()
end

function map.new(nMap, world)
	local s = {}
	s.obsCanvas = love.graphics.newCanvas(nMap.width * nMap.tilewidth, nMap.height * nMap.tileheight)	-- obstáculos
	s.fixtT = p.obtFixtT(nMap.layers, world)
	p.configureCanvas(s.obsCanvas, s.fixtT)
	s.spriteBatchT = p.obtSpriteBatchT(nmap.tilesets, nmpa.layers)
	setmetatable(s, map_mt)
	return s
end

function map:draw()
	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(self.obsCanvas)
	love.graphics.draw(self.worldMap)
end

return map