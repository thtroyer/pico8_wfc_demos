
-- pico-8 hooks
function _init()
	--	title_screen = true
	--	draw_title_screen()
	add(players, player:new(10, rnd(20) + 20, 1))
	add(players, player:new(5, rnd(20) + 40, 2))
	add(snowmen, snowman:new())
	add(snowmen, snowman:new())

	local mapgen = mapgen:new()
	mapgen:generate()
	mapgen:draw()
end

function _update()
	handle_controllers()
	update_players()
	update_snowballs()
	update_snowmen()
	detect_collisions()
end

function _draw()
	-- unused
	if title_screen then
		return
	end

	cls()
	map()
	foreach(snowballs, 
        function(o)
            o:draw()
        end
    )

	foreach(snowmen, 
        function(o)
            o:draw()
        end
    )

	foreach(players, 
        function(o)
            o:draw()
        end
    )
end