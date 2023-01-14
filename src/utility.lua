
-- converts anything to string, even nested tables
function tostring(any) 
	if type(any) == "function" then
		return "function"
	end
	if any == nil then
				return "nil"
	end
	if type(any) == "string" then
		return any
	end
	if type(any) == "boolean" then
		if any then
			return "true"
		end
		return "false"
	end
	if type(any) == "table" then
		local str = "{ "
		for k, v in pairs(any) do
			str = str .. tostring(k) .. "->" .. tostring(v) .. " "
		end
		return str .. "}"
	end
	if type(any) == "number" then
		return "" .. any
	end
	return "unknown"
end

function random(minimum, maximum)
	return rnd(maximum - minimum) + minimum
end

function random_int(low, high)
return flr(rnd(high + 1 - low)) + low
end

function log(msg)
	printh(msg, "log.txt", false)
end

function debug(msg)
	print(msg, 20, 20, 7)
end