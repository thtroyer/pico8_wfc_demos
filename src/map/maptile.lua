
-- maptile
maptile = {}

function maptile:new()
	local o = {}
	setmetatable(o, self)
	self.__index = self

	o.list_of_tiles = {}

	o.tile = -1
	o.x = nil
	o.y = nil

	return o
end

function maptile:entropy()
	return count(self.list_of_tiles)
end

function maptile:is_collapsed()
	return not (self.tile == -1)
end

function maptile:add(tile)
	add(self.list_of_tiles, tile)
end

function maptile:remove(tile)
	del(self.list_of_tiles, tile)
end

function maptile:collapse()
	if (self:is_collapsed()) then
		return
	end

	if (count(self.list_of_tiles) == 0) then
		self.tile = 79
		return
	end

	self.tile = rnd(self.list_of_tiles)

	-- draw once collapsed
	cls()
	mset(self.x, self.y, self.tile)
	map()

	self.list_of_tiles = {}
	add(self.list_of_tiles, self.tile)
end