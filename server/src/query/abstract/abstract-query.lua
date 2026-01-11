local Extendable = require("utility.extendable")

local AbstractQuery = Extendable:extend()

AbstractQuery.query = nil

function AbstractQuery:formatParameters()
	assert(self.query ~= "", "Query not defined.")

	return self.query:gsub(
		":([%w_]+)",
		function(key)
			local value = self.parameters[key]

			assert(value ~= nil, "Missing parameter: " .. key)

			if type(value) == "string" then
				return "'" .. value:gsub("'", "''") .. "'"
			elseif type(value) == "number" then
				return tostring(value)
			else
				error("Unsupported parameter type for " .. key)
			end
		end
	)

end

function AbstractQuery:new(parameters)
	local instance = setmetatable({}, self)

	instance.parameters = parameters or {}

	return instance
end

function AbstractQuery:execute()
	local formatted_query = self:formatParameters()

	PrintDebug("Executing query: " .. formatted_query)

	local result = CharDBQuery(formatted_query)

	return result
end

return AbstractQuery
