local char = require("character")
local stage = require("stage")
local mapa = require("mapa1")
local map = require("map")

function love.load()
	love.window.setMode(mapa.width * mapa.tilewidth, mapa.height * mapa.tileheight )
	stage1 = stage.new(16)
	char1 = char.new(stage1:obtWorld(), 135, 100)
	char2 = char.new(stage1:obtWorld(), 200, 350, nil, "kinematic", false)
	stage1:register(char1)
	stage1:register(char2)
	map.new(mapa, stage1:obtWorld())
end

function love.update(dt)
	stage1:update(dt)
end

function love.draw()
	char2:draw()
	char1:draw()
	stage1:draw()
end