
-- global game logic functions
function handle_controllers()
	for i, player in pairs(players) do
		local mov_x = 0
		if (btn(⬅️, i - 1)) then
			mov_x = -1
		elseif (btn(➡️, i - 1)) then
			mov_x = 1
		end

		local mov_y = 0
		if (btn(⬆️, i - 1)) then
			mov_y = -1
		elseif (btn(⬇️, i - 1)) then
			mov_y = 1
		end

		player:move(mov_x, mov_y)

		if (btn(🅾️, i-1)) then
	add(snowballs, player:throw_snowball())
		end
	end
end

function title_controllers()
	if not title_timer == nil then
		return
	end

	if (btnp(❎, 0)
			or btnp(❎, 1)
			or btnp(🅾️, 0)
	or btnp(🅾️,1)) then
	title_timer = 30
	sfx(1)
	end
end

function update_snowballs()
	for s in all(snowballs) do
		if (s ~= nil) s:update()
	end

	for s in all(snowballs) do
		if s.frames_left == 0 then
			del(snowballs, s)
			break
		end
	end
end

function update_players()
	for p in all(players) do
		p:update()
	end
end

function update_snowmen()
	for s in all(snowmen) do
		s:update()
	end
end

function collide(x1, x1s, y1, y1s, z1, z1s, x2, x2s, y2, y2s, z2, z2s)
	if ((x1 + x1s) > x2) and ((x2 + x2s) > x1) then
		if ((y1 + y1s) > y2) and ((y2 + y2s) > y1) then
			if ((z1 + z1s) > z2) and ((z2 + z2s) > z1) then
				return true
			end
		end
	end
	return false

end

function entitycollide(e1, e2)
	return collide(
			e1.x + e1.xoff,
			e1.xsize,
			e1.y + e1.xoff,
			e1.ysize,
			e1.z,
			e1.zsize,
			e2.x + e2.xoff,
			e2.xsize,
			e2.y + e2.xoff,
			e2.ysize,
			e2.z,
			e2.zsize
	)
end

--deprecated
function entitycollide_bak(e1, e2)
	return collide(
			e1.x + e1.xoff,
			e1.xsize,
			e1.y + e1.xoff,
			e1.ysize,
			e2.x + e2.xoff,
			e2.xsize,
			e2.y + e2.xoff,
			e2.ysize)
end

function detect_collisions()
	for s in all(snowballs) do
		if (s.active) then
			for t in all(snowmen) do
				if (entitycollide(s, t)) then
					t:hit()
					s:hit()
				end
			end
		end
	end

	for s in all(snowballs) do
		if (s.active) then
			for p in all(players) do
				if (entitycollide(p, s)) then
					if (s.thrower ~= p) then
						p:hit(s)
						s:hit()
					end
				end
			end
		end
	end
end

-- currently unused
function draw_title_screen()
	cls()
	print('snowball fight!', 26, 16, 0)
	print('snowball fight!', 25, 15, 7)
	print('press ❎ / 🅾️', 39, 116, 0)
	print('press ❎ / 🅾️', 38, 115, 7)
end