local Extendable = require("utility.extendable")
local InventoryEnum = require("inventory.definition.enum.inventory-enum")

local PlayerInspector = Extendable:extend()

function PlayerInspector:new()
    local instance = setmetatable({}, self)

    return instance
end

function PlayerInspector:getFreeInventorySlots(player)
    local free_slots = 0

    free_slots = free_slots + self:getFreeMainBagSlots(player)

    for bag_id = InventoryEnum.BAG_INVENTORY_SLOT_1, InventoryEnum.BAG_INVENTORY_SLOT_4 do
        free_slots = free_slots + self:getFreeBagSlots(player, bag_id)
    end

    return free_slots
end

function PlayerInspector:getFreeMainBagSlots(player)

    local free_slots = 0

    for i = InventoryEnum.MAIN_BAG_SLOT_START, InventoryEnum.MAIN_BAG_SLOT_END do
        local item = player:GetItemByPos(InventoryEnum.BAG_SLOT_DEFAULT, i)

        if not item then
            free_slots = free_slots + 1
        end
    end

    return free_slots
end

function PlayerInspector:getFreeBagSlots(player, bag_id)
    local free_slots = 0

    if (bag_id < InventoryEnum.BAG_INVENTORY_SLOT_1 or bag_id > InventoryEnum.BAG_INVENTORY_SLOT_4) then
        return free_slots
    end

    local bag = player:GetItemByPos(InventoryEnum.BAG_SLOT_DEFAULT, bag_id)

    if not bag then
        return free_slots
    end

    for slot_id = 1, bag:GetBagSize() do
        local item = player:GetItemByPos(bag:GetBagSlot(), slot_id)

        if not item then
            free_slots = free_slots + 1
        end
    end

    return free_slots
end

return PlayerInspector
