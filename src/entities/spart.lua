
-- snow particles
spart = {}

function spart:new(x, y, z, dx, dy, dz)
	local o = {}
	setmetatable(o, self)
	self.__index = self

	o.x = x
	o.y = y
	o.z = z
	o.grav = -0.5

	o.dx = dx
	o.dy = dy
	o.dz = dz

	o.frames_left = random_int(40, 300)

	return o
end

function spart:update()
	self.frames_left -= 1
	if (self.frames_left == 0) return

	self.x += self.dx
	self.y += self.dy
	self.dz += self.grav
	self.z += self.dz
	-- unused

	if (self.z <= 0) then
		self.z = 0
		self.dx = 0
		self.dy = 0
	end
end

function spart:draw()
	if (self.frames_left <= 0) return
	pset(self.x+4, self.y+4 - (self.z/2), 7)
end