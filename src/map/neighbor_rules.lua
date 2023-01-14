
neighbor_rules = {}

function neighbor_rules:new()
	local o = {}
	setmetatable(o, self)
	self.__index = self

	o.list_of_nbrs = {}

	return o
end

function neighbor_rules:add_neighbors(tile1, tile2)
	local neighbors = {}
	add(neighbors, tile1)
	add(neighbors, tile2)

	add(self.list_of_nbrs, neighbors)
end

-- source : map_tile
-- mapdata:mapdata
-- returns void
function neighbor_rules:propogate(source, mapdata)
	local x = source.x
	local y = source.y
	self:ortho(source, mapdata.map_tiles, x+1, y)
	self:ortho(source, mapdata.map_tiles, x-1, y)
	self:ortho(source, mapdata.map_tiles, x, y+1)
	self:ortho(source, mapdata.map_tiles, x, y-1)
end

-- source : map_tile
-- tiles : list<map_tile>
-- x : int, y : int
-- return void
function neighbor_rules:ortho(source, tiles, x, y)
	log("propogating changes to "..x..","..y)
	neighbor = tiles[x+y*16]
	if (neighbor == nil) then
		log("neighbor not found")
		return
	end

	local states_to_rm = {}

	-- tn=tile_neighbor
	for tn in all(neighbor.list_of_tiles) do
		local change = true
		-- ts = tile_source
		local ts = source.tile
		for r in all(self.list_of_nbrs) do
			if (r[1] == ts and r[2] == tn)
			or (r[2] == ts and r[1] == tn) then
				log("----found match")
				change = false
			end
		end
		if change then
			log("deleting from " .. neighbor.x .. ", " .. neighbor.y .. "; " .. tn)
			--del(neighbor.list_of_tiles, tn)
			--neighbor:remove(tn)
			add(states_to_rm, tn)
		end
	end

	log("bork2")
	log(count(states_to_rm))
	for t in all(states_to_rm) do
		log("bork")
		neighbor:remove(t)
	end
end
