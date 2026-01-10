local AbstractHandler = require("server-message-handler.handler.abstract.abstract-handler")
local PlayerInspector = require("player.inspector.player-inspector")
local SelectStoredMaterialQuantityQuery = require("query.select.select-stored-material-quantity")
local UpdateStoredMaterialQuantityQuery = require("query.update.update-stored-material-quantity")
local ClientHandlerEnum = require("server-message-handler.definition.enum.client-handler-enum")

local WithdrawHandler = AbstractHandler:extend()

function WithdrawHandler:execute(player, data)
    local player_inspector = PlayerInspector:new()

    local item_template_id = 0

    for _, value in pairs(data) do
        item_template_id = value

        break
    end

    if item_template_id == 0 then
        player:SendServerResponse("ItemVault", ClientHandlerEnum.WITHDRAW_RESPONSE, 0, 0)

        PrintError("WithdrawHandler: Invalid item_template_id provided.")

        return
    end

    local stored_quantity_query = SelectStoredMaterialQuantityQuery:new{
        account_id = player:GetAccountId(),
        item_template_id = item_template_id,
    }

    local ale_query = stored_quantity_query:execute()
    local stored_quantity = 0

    if ale_query ~= nil and ale_query:GetRowCount() > 0 then
        local row = ale_query:GetRow()
        stored_quantity = row["quantity"]
    end

    if stored_quantity < 1 then
        player:SendServerResponse("ItemVault", ClientHandlerEnum.WITHDRAW_RESPONSE, item_template_id, 0)

        return
    end

    local free_inventory_slots = player_inspector:getFreeInventorySlots(player)

    if free_inventory_slots == 0 then
        player:SendServerResponse("ItemVault", ClientHandlerEnum.WITHDRAW_RESPONSE, item_template_id, 0)

        return
    end

    local added_item = player:AddItem(item_template_id, 1)

    if not added_item then
        player:SendServerResponse("ItemVault", ClientHandlerEnum.WITHDRAW_RESPONSE, item_template_id, 0)

        return
    end

    if stored_quantity == 1 then
        local update_query = UpdateStoredMaterialQuantityQuery:new{
            account_id = player:GetAccountId(),
            item_template_id = item_template_id,
            quantity = 0,
        }

        update_query:execute()

        return
    end

    local max_stack_size = added_item:GetMaxStackCount()
    local quantity_to_add = math.min(stored_quantity - 1, max_stack_size - 1)

    player:AddItem(item_template_id, quantity_to_add)

    local new_stored_quantity = stored_quantity - (quantity_to_add + 1)

    local update_query = UpdateStoredMaterialQuantityQuery:new{
        account_id = player:GetAccountId(),
        item_template_id = item_template_id,
        quantity = new_stored_quantity,
    }

    update_query:execute()

    player:SendServerResponse("ItemVault", ClientHandlerEnum.WITHDRAW_RESPONSE, item_template_id, new_stored_quantity)

    return
end

return WithdrawHandler
