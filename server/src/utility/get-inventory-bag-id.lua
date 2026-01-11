local InventoryEnum = require("inventory.definition.enum.inventory-enum")

function getInventoryBagID(bag_index)
	if bag_index == nil then
		return nil
	end

	if bag_index < 0 or bag_index > 4 then
		return nil
	end

	if bag_index == 0 then
		return InventoryEnum.BAG_SLOT_DEFAULT
	end

	return bag_index + InventoryEnum.BAG_INVENTORY_SLOT_OFFSET
end

return getInventoryBagID
