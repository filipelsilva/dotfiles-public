REQUIRE = function(...)
	local args = {...}
	local ret = {}
	for _, requirement in ipairs(args) do
		local status_ok, tmp = pcall(require, requirement)
		if not status_ok then
			error("Error requiring " .. requirement)
		end
		table.insert(ret, tmp)
	end
	return unpack(ret)
end
