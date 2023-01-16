
-- utility methods
function tostring(var) 
	if var == nil then
		return "nil"
	end

	if type(var) == "function" then
		return "function"
	end

	if type(var) == "string" then
		return var
	end

	if type(var) == "boolean" then
		if var then
			return "true"
		end
		return "false"
	end

	if type(var) == "table" then
		local table = "{ "
		for k, v in pairs(var) do
			table = table .. tostring(k) .. "->" .. tostring(v) .. " "
		end
		return table .. "}"
	end
	if type(var) == "number" then
		return "" .. var
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

function clearlog()
	printh("", "log.txt", true)
end

function debug(msg)
	print(msg, 20, 20, 7)
end