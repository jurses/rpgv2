local map = {}
local p = {}
local map_mt = {__index = map}

function p.createLayers(layers, world)
	auxBody = nil
	auxShape = nil
	fixT = {}
	spriteT = {}
	quadT = {}
	for k in ipairs(layers) do
		if layers[k].type == "tilelayer" then
			x = 0
			y = 0
			for i, v in ipairs(v.tilelayer) do
				x = x + map.tilewidth
				y = y + map.tileheight
			end
		elseif layers[k].type == "objectgroup" then
			for j, w in ipairs(v.objects) do
				auxBody = love.physics.newBody(world, (w.x + w.width/2), (w.y + w.height/2), "static")
				auxShape = love.physics.newRectangleShape(w.width, w.height)
				table.insert(fixT, love.physics.newFixture(auxBody, auxShape))
			end
		end
	end
	return fixT
end

function p.createTileset(map)
	tileSetT = {}
	for k in ipairs(map.tilesets) do
		quadT = {}
		tileSetImg = love.graphics.newImage(map.tilesets[k].image)
		for y = 0, map.tilesets[k].image.height, map.tilesets[k].tileheight do
			for x = 0, map.tilesets[k].imagewidth, map.tilesets[k].tilewidth do
				-- i*m + j; y*h +x
				id = y/map.tilesets[k].tileheight * map.tilesets[k].imageheight/map.tilesets[k].tileheight + x/map.tilesets[k].tilewidth + 
				table.insert(quadT, {love.graphics.newQuad(x, y, map.tilesets[k].tilewidth, map.tilesets[k].height, map.tilesets[k].imagewidth, map.tilesets[k].imageheight), id})
			end
		end
		table.insert(tileSetT, {quadT, map.tilesets[k].name})
	end
	return tileSetT
end

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
	s.spriteBatchT = p.obtSpriteBatchT(nMap.tilesets, nMap.layers)
	setmetatable(s, map_mt)
	return s
end

function map:draw()
	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(self.obsCanvas)
	love.graphics.draw(self.worldMap)
end

return map