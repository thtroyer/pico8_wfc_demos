
-- player object
player = {}

function player:new(x, y, player_id)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.x = x or 10
	o.y = y or 20
	o.dx = 0
	o.dy = 0
	o.z = 0
	o.xsize = 8
	o.ysize = 8
	o.zsize = 15
	o.xoff = 0
	o.yoff = 0
	o.zoff = 0
	o.hitdx = 0
	o.hitdy = 0

	o.looking_dir = "⬇️"
	o.walk_timer = nil
	o.walk_state = 0
	o.hearts = 3
	o.player_id = player_id
	o.hit_timer = nil
	o.flicker = false
	o.throw_timer = nil

	o.sprite_id = 1
	if (player_id == 1) then
		o.sprite_id = 2
	end
	return o
end

function player:draw()
	self:countdown_timer()

	if (self.hearts <= 0) then
		return
	end

	local so = (self.player_id - 1) * 3
	-- disabling walking animation for now
	--	spr(self.sprite_id, self.x, self.y, 1, 1, self.is_looking_left)
	if (self.looking_dir == "⬆️⬅️") then
		spr(128 + so, self.x, self.y, 1, 1)
	elseif (self.looking_dir == "⬆️") then
		spr(129 + so, self.x, self.y, 1, 1)
	elseif (self.looking_dir == "⬆️➡️") then
		spr(130 + so, self.x, self.y, 1, 1)
	elseif (self.looking_dir == "⬅️") then
		spr(144 + so, self.x, self.y, 1, 1)
	elseif (self.looking_dir == "➡️") then
		spr(146 + so, self.x, self.y, 1, 1)
	elseif (self.looking_dir == "⬇️⬅️") then
		spr(160 + so, self.x, self.y, 1, 1)
	elseif (self.looking_dir == "⬇️") then
		spr(161 + so, self.x, self.y, 1, 1)
	elseif (self.looking_dir == "⬇️➡️") then
		spr(162 + so, self.x, self.y, 1, 1)
	end

	self:draw_hearts()
end

function player:countdown_timer()
	-- countdown hit timer
	if not (self.hit_timer == nil) then
		self.hit_timer -= 1
	if (self.hit_timer <= 0) then
		self.hit_timer = nil
		self.flicker = false
		end
	end
end

function player:move(mov_x, mov_y)

	if (mov_x == 0 and mov_y == 0) then
		self.walk_timer = nil
		self.walk_state = 0
		return
	end

	if (self.walk_timer == nil) then
		self.walk_timer = 5
	end

	if (self.walk_timer == 0) then
		self.walk_timer = 5
		self.walk_state += 1
		if self.walk_state > 3 then
			self.walk_state = 0
		end
	end

	if not (self.hit_timer == nil) then
		self.dx = mov_x * 0.3
		self.dy = mov_y * 0.3
	else
		self.dx = mov_x
		self.dy = mov_y
	end

	self.looking_dir = ""

	if (mov_y == 1) self.looking_dir = self.looking_dir .. "⬇️"
	if (mov_y == -1) self.looking_dir = self.looking_dir .. "⬆️"

	if (mov_x == 1) self.looking_dir = self.looking_dir .. "➡️"
	if (mov_x == -1) self.looking_dir = self.looking_dir .. "⬅️"

	self.x += self.dx
	self.y += self.dy

	-- boundries
	if self.y > 130 then
		self.y = 130
	elseif self.y < -8 then
		self.y = -8
	end

	if self.x > 130 then
		self.x = 130
	elseif self.x < -8 then
		self.x = -8
	end
end

function player:throw_snowball()
	if not (self.throw_timer == nil) then
		return
	end

	self.throw_timer = 13

	local s = snowball:new(self.x, self.y + 2, self)

	--if (sub(self.looking_dir, 2, 2) == "⬅️") then
	if (self.looking_dir == "⬅️") then
		s.dx = -3 + random(-.04, .04)
		s.dy = random(-.15, .15)
	elseif (self.looking_dir == "➡️") then
		s.dx = 3 + random(-.04, .04)
		s.dy = random(-.15, .15)
	end

	if (self.looking_dir == "⬆️") then
		s.dy = -3 + random(-.04, .04)
		s.dx = random(-.15, .15)
	elseif self.looking_dir == "⬇️" then
		s.dy = 3 + random(-.04, .04)
		s.dx = random(-.15, .15)
	end

	s.dz = 2.5

	return s
end

function player:draw_hearts()
	if (1 == 1) then
		return
	end
	spr(24 + self.player_id, 0, (self.player_id * 10) - 7)
	for i = 1, self.hearts, 1 do
		spr(24, 7 + ((i - 1) * 15), (self.player_id * 8) - 8 + 3)
	end
end

function player:hit(snowball)
	self.hitdx += (snowball.dx/2)
	self.hitdy += (snowball.dy/2)
end

function sign(x)
	return x / abs(x)
end

function player:update()
	self.x += self.hitdx
	self.y += self.hitdy

	self.hitdx -= sign(self.hitdx) * .5
	self.hitdy -= sign(self.hitdy) * .5
	if (self.hitdx < 0.1) self.hitdx = 0
	if (self.hitdy < 0.1) self.hitdy = 0

	if not (self.throw_timer == nil) then
		self.throw_timer -= 1
		if (self.throw_timer == 0) self.throw_timer = nil
		end
end