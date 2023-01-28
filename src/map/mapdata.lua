
-- mapdata 
mapdata = {}

function mapdata:new()
	local o = {}
	setmetatable(o, self)
	self.__index = self

	-- list<map_tiles>
	o.map_tiles = {}
	return o
end


function mapdata:initialize(tiles)
	local map_tiles = {}

	for y = 0, 15 do
		for x = 0, 15 do
			map_tiles[x+y*16] = maptile:new()
			map_tiles[x+y*16].x = x
			map_tiles[x+y*16].y = y

			for t in all(tiles) do
				map_tiles[x+y*16]:add(t)
			end
		end
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
		if not t:is_collapsed() and #t.list_of_tiles ~= 0 then
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

	return l_list
end
