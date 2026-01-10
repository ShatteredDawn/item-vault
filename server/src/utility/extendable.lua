local Extendable = {}

function Extendable:extend()
    local subclass = {}

    subclass.__index = subclass

    setmetatable(subclass, { __index = self })

    return subclass
end

return Extendable
