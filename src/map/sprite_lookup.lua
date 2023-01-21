

sides = {
	-- consts
	top = 0,
	bottom = 1,
	right = 2,
	left = 3,
	all = 4
}

function get_sprite_pixels(sprite_id, side)
    local sprite_x_tile = sprite_id % 16
    local sprite_y_tile = flr(sprite_id / 16)

    local is_x, is_y, x_offset, y_offset = 0,0,0,0

    if (side == sides.top) then
        is_x = 1
    elseif (side == sides.bottom) then
        is_x = 1
        y_offset = 7
    elseif (side == sides.left) then
        is_y = 1
    elseif (side == sides.right) then
        is_y = 1
        x_offset = 7
    end

    local pixels = ""

    for i=0,7 do
        pixels ..= "." .. sget((sprite_x_tile * 8) + (i * is_x) + x_offset,
            (sprite_y_tile * 8) + (i * is_y) + y_offset)
    end

    return pixels
end

