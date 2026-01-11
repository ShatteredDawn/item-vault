local function concat_tables(a, b)
    local result = {}

	if a == nil and b == nil then
		return result
	end

	if a == nil then
		return b
	end

	if b == nil then
		return a
	end

    for i = 1, #a do
        result[#result + 1] = a[i]
    end

    for i = 1, #b do
        result[#result + 1] = b[i]
    end

    return result
end

return concat_tables
