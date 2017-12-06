local quantum = require("quantum")

local chronos = {}
local chronos_mt = {__index = chronos}
local p = {}

function chronos.new()
	local s = {}
	s.q = {}
	setmetatable(s, chronos_mt)
	return chronos
end

function chronos:register(deadTime)
	cTime = love.time.getTime()
	for i, v in ipairs(self.q) do
		if not v then
			table.insert(self.q, quantum.new(deadtime + cTime))
			return i
		end
	end
end

function chronos:update()
	cTime = love.time.getTime()
	for i, v in ipairs(self.q) do
		if v and not v.signal and v.getTime() - cTime <= 0 then
			v:setSignal()
		end
	end
end

function chronos:ready(id)
	return self.q[id]:stateSignal()
end

function chronos:end(id)
	self.q[id] = nil
end

function chronos:refresh()