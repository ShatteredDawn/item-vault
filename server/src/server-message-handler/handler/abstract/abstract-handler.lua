local Extendable = require("utility.extendable")

local AbstractHandler = Extendable:extend()

function AbstractHandler:new()
	local instance = setmetatable({}, self)

	return instance
end

function AbstractHandler:handle(message, player)
	error("Abstract method 'handle' not implemented.")
end

return AbstractHandler
