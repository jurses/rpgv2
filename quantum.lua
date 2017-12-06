local quantum = {}
local quantum_mt = {__index = quantum}
local p = {}

function quantum.new(time)
	local s = {}
	s.deadTime = love.timer.getTime() + time
	s.signal = false
	setmetatable(s, quantum_mt)
	return s
end

function quantum:refresh(futureTime)
	self.deadTime = love.timer.getTime() + futureTime
end

function quantum:update()
	self.signal = self.deadTime - love.timer.getTime() <= 0
end

function quantum:getDeadTime()
	return self.deadTime
end

function quantum:stateSignal()
	return self.signal
end

return quantum