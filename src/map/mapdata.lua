
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


function mapdata:initialize()
	local map_tiles = {}

	for y = 0, 15 do
		for x = 0, 15 do
			map_tiles[x+y*16] = maptile:new()
			map_tiles[x+y*16].x = x
			map_tiles[x+y*16].y = y

			-- map_tiles[x+y*16]:add(64)
			-- map_tiles[x+y*16]:add(65)
			-- map_tiles[x+y*16]:add(80)
			map_tiles[x+y*16]:add(64)
			map_tiles[x+y*16]:add(65)
			map_tiles[x+y*16]:add(66)
			map_tiles[x+y*16]:add(80)
			map_tiles[x+y*16]:add(81)
			map_tiles[x+y*16]:add(82)
			map_tiles[x+y*16]:add(83)
			map_tiles[x+y*16]:add(84)
			map_tiles[x+y*16]:add(85)
			map_tiles[x+y*16]:add(86)
			map_tiles[x+y*16]:add(87)
			map_tiles[x+y*16]:add(96)
			map_tiles[x+y*16]:add(97)
			map_tiles[x+y*16]:add(98)
			map_tiles[x+y*16]:add(99)
			map_tiles[x+y*16]:add(100)
			map_tiles[x+y*16]:add(101)
			map_tiles[x+y*16]:add(102)
			map_tiles[x+y*16]:add(103)
			map_tiles[x+y*16]:add(88)
			map_tiles[x+y*16]:add(89)
			map_tiles[x+y*16]:add(104)
			map_tiles[x+y*16]:add(105)

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
