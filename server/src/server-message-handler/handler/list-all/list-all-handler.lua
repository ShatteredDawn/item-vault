local AbstractHandler = require("server-message-handler.handler.abstract.abstract-handler")
local SelectAllStoredMaterialQuery = require("query.select.select-all-stored-material")
local ClientHandlerEnum = require("server-message-handler.definition.enum.client-handler-enum")

local ListAllHandler = AbstractHandler:extend()

function ListAllHandler:execute(player)
	local query = SelectAllStoredMaterialQuery:new{
		account_id = player:GetAccountId(),
	}

	local aleQuery = query:execute()

	local results = {}

	if aleQuery ~= nil and aleQuery:GetRowCount() > 0 then
		repeat
			local row = aleQuery:GetRow()

			table.insert(results, {
				item_template_id = row["item_template_id"],
				quantity = row["quantity"],
			})
		until not aleQuery:NextRow()
	end

	player:SendServerResponse("ItemVault", ClientHandlerEnum.LIST_ALL_RESPONSE, results)
end

return ListAllHandler
