local AbstractHandler = require("server-message-handler.handler.abstract.abstract-handler")
local InventoryEnum = require("definition.enum.inventory-enum")
local AllowedItemEnum = require("storage.definition.enum.allowed-item-enum")
local ClientHandlerEnum = require("server-message-handler.definition.enum.client-handler-enum")
local Storage = require("storage.storage")
local concat_tables = require("utility.concat_tables")

local DepositAllHandler = AbstractHandler:extend()

function DepositAllHandler:execute(player)
	local materials = self:getAllInventoryMaterials(player)

	for _, material in pairs(materials) do
		local item = player:GetItemByPos(material.bag_slot, material.slot)

		if not item then
			goto continue
		end

		Storage:depositItem(player, item)

		::continue::
	end

	player:SendServerResponse("ItemVault", ClientHandlerEnum.DEPOSIT_ALL_RESPONSE)
end

function DepositAllHandler:getAllInventoryMaterials(player)
	local materials = {}
	local main_bag_materials = self:getMainBagMaterials(player)

	materials = concat_tables(materials, main_bag_materials)

	local bags_materials = self:getBagsMaterials(player)

	materials = concat_tables(materials, bags_materials)

	return materials
end

function DepositAllHandler:getMainBagMaterials(player)
	local materials = {}

	for slot = InventoryEnum.MAIN_BAG_SLOT_START, InventoryEnum.MAIN_BAG_SLOT_END do
		local item = player:GetItemByPos(InventoryEnum.BAG_SLOT_DEFAULT, slot)

		if not item then
			goto continue
		end

		local item_template = item:GetItemTemplate()

		if not item_template then
			goto continue
		end

		if not AllowedItemEnum[item_template:GetItemId()] then
			goto continue
		end

		table.insert(materials, {
			bag_slot = InventoryEnum.BAG_SLOT_DEFAULT,
			slot = slot
		})

		::continue::
	end

	return materials
end

function DepositAllHandler:getBagsMaterials(player)
	local result = {}

	for i = InventoryEnum.BAG_INVENTORY_SLOT_1, InventoryEnum.BAG_INVENTORY_SLOT_4 do
		local bag_materials = self:getBagMaterials(player, i)

		result = concat_tables(result, bag_materials)
	end

	return result
end

function DepositAllHandler:getBagMaterials(player, bag_slot)
	local materials = {}

	if bag_slot < InventoryEnum.BAG_INVENTORY_SLOT_1 or bag_slot > InventoryEnum.BAG_INVENTORY_SLOT_4 then
		return
	end

	local bag = player:GetItemByPos(InventoryEnum.BAG_SLOT_DEFAULT, bag_slot)

	if not bag or not bag:IsBag() then
		return
	end

	local bag_size = bag:GetBagSize()

	for slot = 0, bag_size do
		local item = player:GetItemByPos(bag_slot, slot)

		if not item then
			goto continue
		end

		local item_template = item:GetItemTemplate()

		if not item_template then
			goto continue
		end

		if not AllowedItemEnum[item_template:GetItemId()] then
			goto continue
		end

		table.insert(materials, {
			bag_slot = bag_slot,
			slot = slot
		})

		::continue::
	end

	return materials
end

return DepositAllHandler
