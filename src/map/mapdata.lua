
-- mapdata 
mapdata = {}

function mapdata:new()
	local o = {}
	setmetatable(o, self)
	self.__index = self

	-- list<map_tiles>
	o.map_tiles = {}
	log("mapdata:new()")
	return o
end


function mapdata:initialize()
	local map_tiles = {}

	log("generating map tiles")
	for y = 0, 15 do
		for x = 0, 15 do
			-- log(x..","..y)
			-- log(x+y*16)
			-- log("adding " .. x+y*16)
			map_tiles[x+y*16] = maptile:new(64, 65)
			map_tiles[x+y*16].x = x
			map_tiles[x+y*16].y = y
			map_tiles[x+y*16]:add(102)
			map_tiles[x+y*16]:add(103)
			map_tiles[x+y*16]:add(86)
			map_tiles[x+y*16]:add(87)
			map_tiles[x+y*16]:add(70)
			map_tiles[x+y*16]:add(71)
		end
		-- log(tostring(map_tiles))
	end
	self.map_tiles = map_tiles
end

-- x: int, y: int
-- returns map_tile
function mapdata:get_maptile(x, y)
	return self.map_tiles[x+y*16]
end

-- x: int, y: int
-- returns list<map_tile>
function mapdata:get_maptile_neighbors(x, y)
	function add_if_notnil(list, i)
		if ( not (i == nil)) then
			add(list, i)
		end
		return list
	end

	neighbors = {}
	neighbors = add_if_notnil(self.get_maptile(x+1, y))
	neighbors = add_if_notnil(self.get_maptile(x-1, y))
	neighbors = add_if_notnil(self.get_maptile(x,y+1))
	neighbors = add_if_notnil(self.get_maptile(x, y-1))
	return neighbors
end

-- find tiles with lowest entropy
-- returns list<maptile>
function mapdata:lowest()
	local lowest_entropy = 9999
	local l_list = {}

	for t in all(self.map_tiles) do
		if not t:is_collapsed() then
			local ent = t:entropy()
			if ent == lowest_entropy then
				add(l_list, t)
			elseif ent < lowest_entropy then
				lowest_entropy = ent
				l_list = {}
				add(l_list, t)
			end
		end
	end

	log("found " .. count(l_list))
	return l_list
end
