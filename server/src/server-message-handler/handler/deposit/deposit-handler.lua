local AbstractHandler = require("server-message-handler.handler.abstract.abstract-handler")
local ClientHandlerEnum = require("server-message-handler.definition.enum.client-handler-enum")
local Storage = require("storage.storage")

local DepositHandler = AbstractHandler:extend()

function DepositHandler:execute(player, data)
    local bag_id = data[1] or nil
    local slot_id = data[2] or nil

    if bag_id == nil or slot_id == nil then
        PrintError("DepositHandler: Invalid bag_id or slot_id provided.")

        return
    end

    local item = player:GetItemByPos(bag_id, slot_id)
    local item_template = item:GetItemTemplate()
    local updated_quantity = Storage:depositItem(player, item)
    local item_template_id = item_template:GetItemId()

    player:SendServerResponse("ItemVault", ClientHandlerEnum.DEPOSIT_RESPONSE, item_template_id, updated_quantity)
end

return DepositHandler
