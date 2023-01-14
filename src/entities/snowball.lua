
-- snowball and snow particle objects
snowball = {}

function snowball:new(x, y, thrower)
	local o = {}
	setmetatable(o, self)
	self.__index = self

	o.x = x
	o.y = y
	o.sprite_id = 0
	o.z = 0
	o.shadow = true

	o.dx = 0
	o.dy = 0
	o.dz = 0
	o.grav = -0.25
	o.active = true

	o.xoff = 4
	o.yoff = 4
	o.xsize = 2
	o.ysize = 2
	o.zsize = 2

	o.thrower = thrower

	o.frames_left = random_int(300,600)
	o.particles = {}

	return o
end

function snowball:update()
	self.frames_left -= 1
	if (self.frames_left == 0) return

	self.x += self.dx
	self.y += self.dy
	self.dz += self.grav
	self.z += self.dz
	if (self.z <= 0) then
		if (self.dz ~= self.grav) then
			self:splat()
		end
		self.z = 0
		self.dx = 0
		self.dy = 0
		self.dz = 0
	end

	for p in all(self.particles) do
		p:update()
	end

	if random_int(0, 100) <= 2 then
		add(self.particles,
			spart:new(self.x, self.y, self.z, self.dx/2, self.dy/2, self.dz)
		)
	end
end

function snowball:splat()
	if ( not self.active) return

	for i = 1, random_int(10, 16), 1 do
		add(
			self.particles,
			spart:new(
				self.x, self.y, self.z,
				self.dx/2 + random(-0.4, 0.4), self.dy/2 + random(-0.4, 0.4), 1.2 + random(-1, 1)
			)
		)
	end

	self.active = false
end

function snowball:hit()
	local xpos = 1
	local xneg = -1
	local ypos = 1
	local yneg = -1

	if (self.dx>1) then
		xpos= 0
	elseif (self.dx < -1) then
		xneg = 0
	end

	if (self.dy>1) then
		ypos = 0
	elseif (self.dy < -1) then
		yneg = 0
	end


	for i = 1, random_int(5, 8), 1 do
		add(
			self.particles,
			spart:new(
				self.x, self.y, self.z,
				random(xneg, xpos),
				random(yneg, ypos),
				1 + random(-.5, .5)
			)
		)
	end
	
	self.active = false
	self.dx = 0
	self.dy = 0
	self.dz = 0
end

function snowball:is_down()
	return self.z == 0
end

function snowball:draw()
	if (self.frames_left == 0) return

	self.shadow = not self.shadow
	spr(self.sprite_id, self.x, self.y-(self.z/2))
	if (self.z ~= 0 and self.shadow) then
		spr(20, self.x, self.y)
	end

	for p in all(self.particles) do
		p:draw()
	end
end
