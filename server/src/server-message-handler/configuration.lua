local ServerResponseEnum = require("server-message-handler.definition.enum.server-response-enum")
local ListAllHandler = require("server-message-handler.handler.list-all/list-all-handler")
local DepositAllHandler = require("server-message-handler.handler.deposit-all/deposit-all-handler")
local DepositHandler = require("server-message-handler.handler.deposit/deposit-handler")
local WithdrawHandler = require("server-message-handler.handler.withdraw/withdraw-handler")

function ListAll(player)
	local handler = ListAllHandler:new()

	return handler:execute(player)
end

function DepositAll(player)
	local handler = DepositAllHandler:new()

	handler:execute(player)
end

function Deposit(player, bag_id, slot_id)
	local handler = DepositHandler:new()

	handler:execute(player, bag_id, slot_id)
end

function Widthdraw(player, item_template_id)
	local handler = WithdrawHandler:new()

	handler:execute(player, item_template_id)
end

local configuration = {
	Prefix = "ItemVault",
	Functions = {
		[ServerResponseEnum.LIST_ALL] = "ListAll",
		[ServerResponseEnum.DEPOSIT_ALL] = "DepositAll",
		[ServerResponseEnum.DEPOSIT] = "Deposit",
		[ServerResponseEnum.WITHDRAW] = "Widthdraw"
	}
}


return configuration
