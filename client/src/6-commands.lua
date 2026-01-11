local _, internal = ...

local function addSlashCommand(key, aliases, callable)
	for i, alias in ipairs(aliases) do
		_G["SLASH_"..key..i] = alias
	end

	SlashCmdList[key] = callable
end

addSlashCommand(
	"ITEMVAULT",
	{
		"/itemvault",
		"/iv"
	},
	function()
		ItemVault:ToggleWindow()
	end
)

addSlashCommand(
	"ITEMVAULT_REFRESH",
	{
		"/ivr"
	},
	function()
		ItemVault:RefreshWindow()
	end
)

addSlashCommand(
	"ITEMVAULT_WITHDRAW",
	{
		"/ivw"
	},
	function(msg)
		if msg == "" then
			print("Usage: /ivw <item_template_id>")
			return
		end

		local item_template_id = tonumber(msg) or 0

		ItemVault:Withdraw(item_template_id)
	end
)

addSlashCommand(
	"ITEMVAULT_DEPOSIT",
	{
		"/ivd"
	},
	function(msg)
		if msg == "" then
			print("Usage: /ivd <bag_id> <slot_id>")
			return
		end

		local parsed_message = string.gmatch(msg, "%d+")

		local bag_id = tonumber(parsed_message() or "0")
		local slot_id = tonumber(parsed_message() or "0")

		ItemVault:Deposit(bag_id, slot_id)
	end
)

addSlashCommand(
	"ITEMVAULT_DEPOSITALL",
	{
		"/ivda"
	},
	function()
		ItemVault:DepositAll()
	end
)
