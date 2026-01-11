local _, internal = ...

local SERVER_FUNCTION = {
	LIST_ALL = 1,
	DEPOSIT_ALL = 2,
	DEPOSIT = 3,
	WITHDRAW = 4
}

local CLIENT_FUNCTION = {
	LIST_ALL_RESPONSE = 1,
	DEPOSIT_ALL_RESPONSE = 2,
	DEPOSIT_RESPONSE = 3,
	WITHDRAW_RESPONSE = 4
}

local item_quantities = {}

local function getItemQuantity(item_template_id)
	return item_quantities[item_template_id] or 0
end

local function listAll()
	SendClientRequest("ItemVault", SERVER_FUNCTION.LIST_ALL)
end

local function depositAll()
	SendClientRequest("ItemVault", SERVER_FUNCTION.DEPOSIT_ALL)
end

local function deposit(bag_id, slot_id)
	SendClientRequest("ItemVault", SERVER_FUNCTION.DEPOSIT, bag_id, slot_id)
end

local function withdraw(item_template_id)
	SendClientRequest("ItemVault", SERVER_FUNCTION.WITHDRAW, item_template_id)
end

function ItemVault_onListAllResponse(player_name, data)
	for i, entry in ipairs(data[1]) do
		local item_template_id = entry.item_template_id
		local quantity = entry.quantity
		item_quantities[item_template_id] = quantity
	end

	ItemVault:RefreshWindow()
end

function ItemVault_onWithdrawResponse(player_name, data)
	local item_template_id = data[1] or 0
	local quantity = data[2] or 0

	if item_template_id == 0 then
		print("Withdraw failed: Item not found or insufficient quantity.")

		return
	end

	item_quantities[item_template_id] = quantity

	ItemVault:RefreshWindow()
end

function ItemVault_onDepositAllResponse(player_name)
	SendClientRequest("ItemVault", SERVER_FUNCTION.LIST_ALL)
end

function ItemVault_onDepositResponse(player_name, data)
	local item_template_id = data[1] or 0
	local quantity = data[2] or 0

	if item_template_id == 0 then
		print("Deposit failed.")

		return
	end

	item_quantities[item_template_id] = quantity

	ItemVault:RefreshWindow()
end

RegisterServerResponses({
	Prefix = "ItemVault",
	Functions = {
		[CLIENT_FUNCTION.LIST_ALL_RESPONSE   ] = "ItemVault_onListAllResponse",
		[CLIENT_FUNCTION.DEPOSIT_ALL_RESPONSE] = "ItemVault_onDepositAllResponse",
		[CLIENT_FUNCTION.DEPOSIT_RESPONSE    ] = "ItemVault_onDepositResponse",
		[CLIENT_FUNCTION.WITHDRAW_RESPONSE   ] = "ItemVault_onWithdrawResponse",
	}
})

internal.getItemQuantity = getItemQuantity
internal.listAll = listAll
internal.withdraw = withdraw
internal.depositAll = depositAll
internal.deposit = deposit
