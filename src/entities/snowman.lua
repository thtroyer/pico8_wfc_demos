
-- snowman target
snowman = {}

function snowman:new()
	local o = {}
	setmetatable(o, self)
	self.__index = self

	o.xoff = 0
	o.yoff = 0
	o.xsize = 8
	o.ysize = 12
	o.z = 0
	o.zsize = 30

	o.x = random_int(64, 120)
	o.y = random_int(20, 114)
	o.health = 100
	o.flipx = random_int(0, 1) == 0

	return o
end

function snowman:checkcollision(snowball)
end

function snowman:hit()
	self.health -= 10
	self.zsize = 30 - (self:states()*3)
end

function snowman:update()
	--self.health -= 1
end

function snowman:states()
	local h = self.health
	if (h >= 90) return 0
	if (h <= 90 and h > 60) return 1
	if (h <= 60 and h > 30) return 2
	if (h <= 30 and h > 0) return 3
	if (h <= 0) return 4
end

function snowman:draw()
	sprite = 42 + self:states()
	spr(sprite,
	self.x, self.y-8,
	1, 2,
	self.flipx)

end