
-- maptile
maptile = {}

function maptile:new()
	local o = {}
	setmetatable(o, self)
	self.__index = self

	o.list_of_tiles = {}

	o.tile = nil
	o.x = nil
	o.y = nil

	return o
end

function maptile:entropy()
	return count(self.list_of_tiles)
end

function maptile:is_collapsed()
	return not (self.tile == nil)
end

function maptile:add(tile)
	add(self.list_of_tiles, tile)
end

function maptile:remove(tile)
	log("removing"..tile .." from " ..x..","..y)
	del(self.list_of_tiles, tile)
	for s in all(self.list_of_tiles) do
		log("s: " ..s)
	end
end

function maptile:collapse()
	if (self:is_collapsed()) then
		log("already collapsed")
		return
	end

	log("collapsing")
	log("tiles:")
	log(self.list_of_tiles)
	log(count(self.list_of_tiles))
	if (count(self.list_of_tiles) == 0) then
		self.tile = 86
		log ("something broke")
		return
	end
	self.tile = rnd(self.list_of_tiles)

	-- draw once collapsed
	cls()
	mset(self.x, self.y, self.tile)
	map()
	log("mset " .. self.x .. "," .. self.y .. " as " .. self.tile)

	self.list_of_tiles = {}
	add(self.list_of_tiles, self.tile)
	log("tile: " .. self.tile)
	log(self:is_collapsed())
end