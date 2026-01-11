local _, internal = ...

local function isWindowVisible()
	return internal.initialized and internal.window:IsShown()
end

ItemVault = {}

function ItemVault:RefreshWindow()
	if not isWindowVisible() then
		return
	end

	internal.refreshAllButtons()
end

function ItemVault:ShowWindow()
	if not internal.initialized then
		internal.initialize()
	end

	internal.refreshAllButtons()
	internal.window:Show()
	PlaySound("GuildVaultOpen")
end

function ItemVault:HideWindow()
	if isWindowVisible() then
		return
	end

	internal.window:Hide()
end

function ItemVault:ToggleWindow()
	if isWindowVisible() then
		ItemVault:HideWindow()
		return
	end

	ItemVault:ShowWindow()
end

function ItemVault:DepositAll()
	internal.depositAll()
end

function ItemVault:Withdraw(item_template_id)
	internal.withdraw(item_template_id)
end

function ItemVault:Deposit(bag_id, slot_id)
	internal.deposit(bag_id, slot_id)
end
