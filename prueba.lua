a = {}
a.prototipo = {
	value = 50
}
a_mt = {__index = a.prototipo}

function a.new(v)
	local inst = {
		value = v or a.prototipo.value
	}
	setmetatable(inst, a_mt)
	return inst
end

function a:show()
	print(self.value)
end

x = a.new()
y = a.new(23)

x:show()
y:show()