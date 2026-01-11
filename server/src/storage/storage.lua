local AllowedItemEnum = require("storage.definition.enum.allowed-item-enum")
local SelectStoredMaterialQuantityQuery = require("query.select.select-stored-material-quantity")
local UpdateStoredMaterialQuantityQuery = require("query.update.update-stored-material-quantity")

local Storage = {}

function Storage:isAllowedItem(item)
	if item == nil then
		PrintError("Storage: Cannot evaluated allowed item on nil item.")

		return false
	end

	local item_template_id = item:GetEntry()

	if not AllowedItemEnum[item_template_id] then
		PrintError("Storage: Item template ID " .. item_template_id .. " is not allowed for deposit.")

		return false
	end

	return true
end

function Storage:depositItem(player, item)
	if not self:isAllowedItem(item) then
		return
	end

	local quantity_to_add = item:GetCount()
	local item_template_id = item:GetEntry()

	PrintDebug("Storage: Depositing item_template_id " .. item_template_id .. " with quantity " .. quantity_to_add)

	local updated_quantity = quantity_to_add

	local stored_quantity_query = SelectStoredMaterialQuantityQuery:new{
		account_id = player:GetAccountId(),
		item_template_id = item_template_id,
	}

	local ale_query = stored_quantity_query:execute()

	if ale_query ~= nil and ale_query:GetRowCount() > 0 then
		local row = ale_query:GetRow()

		PrintDebug("Storage: Existing stored quantity: " .. row["quantity"])

		updated_quantity = quantity_to_add + row["quantity"]
	end

	PrintDebug("Storage: Updated stored quantity: " .. updated_quantity)

	local update_query = UpdateStoredMaterialQuantityQuery:new{
		account_id = player:GetAccountId(),
		item_template_id = item_template_id,
		quantity = updated_quantity,
	}

	update_query:execute()

	PrintDebug("Storage: Removing item " .. item:GetGUIDLow() .. " (" .. quantity_to_add ..") from player's inventory.")

	player:RemoveItem(item, quantity_to_add)

	return updated_quantity
end

return Storage
