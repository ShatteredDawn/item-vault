local _, internal = ...

internal.initialized = false

local function makeFrameMovable(frame)
	frame:SetMovable(true)
	frame:SetClampedToScreen(true)
	frame:EnableMouse(true)
	frame:RegisterForDrag(true)
	frame:SetScript("OnMouseDown", function() frame:StartMoving() end)
	frame:SetScript("OnMouseUp", function() frame:StopMovingOrSizing() end)
end

local function makeFrameCloseOnEscape(frame)
	tinsert(UISpecialFrames, frame:GetName())
end

local function format_quantity(quantity)
	if quantity >= internal.MAX_QUANTITY then
		return "MAX"
	end

	if quantity < 10000 then
		-- 0 to 9999
		return quantity
	end

	if quantity < 1000000 then
		-- 10k to 999k
		return math.floor(quantity / 1000) .. "k"
	end

	if quantity < 100000000 then
		-- 1M to 99M
		return math.floor(quantity / 1000000) .. "M"
	end

	-- 100M or more
	return "*"
end

local function updateItemButton(button, quantity)
	button.count = quantity;

	local counter = _G[button:GetName().."Count"];

	if quantity == 0 then
		counter:Hide()
		button:SetAlpha(0.3)
		return
	end

	counter:SetText(format_quantity(quantity));
	counter:Show()
	button:SetAlpha(1)
end
internal.updateItemButton = updateItemButton

local function refreshItemButton(button)
	local quantity = internal.getItemQuantity(button:GetID())

	updateItemButton(button, quantity)
end
internal.refreshItemButton = refreshItemButton

local function refreshAllButtons()
	for i, button in ipairs(internal.itemSlots) do
		refreshItemButton(button)
	end
end
internal.refreshAllButtons = refreshAllButtons

local function initializeItemButton(button, item)
	button:SetID(item.id)
	button.isBag = true
	button:RegisterForClicks("LeftButtonUp", "RightButtonUp")

	button.categories = item.categories
	SetItemButtonTexture(button, item.icon)
	refreshItemButton(button)

	button:SetScript(
		"OnClick",
		function(self, button_name, down)
			if button_name == "LeftButton" then
				print("Item:", button:GetID())
			end

			if button_name == "RightButton" then
				internal.withdraw(button:GetID())
			end
		end
	)

	button:HookScript(
		"OnEnter",
		function()
			GameTooltip:SetOwner(button, "ANCHOR_TOP")
			GameTooltip:SetHyperlink("item:"..button:GetID())
			GameTooltip:Show()
		end
	)

	button:HookScript(
		"OnLeave",
		function()
			GameTooltip:Hide()
		end
	)
end

-- Function to update the material list display
local function generateItemSlots()

	local content = internal.content

	local item_slots = {}
	internal.itemSlots = item_slots

	local data = internal.data

	internal.data = nil

	content:SetSize(
		3 + internal.MAX_COLUMN * internal.ITEM_SLOT_WIDTH,
		math.ceil(#data.items / internal.MAX_COLUMN) * internal.ITEM_SLOT_WIDTH + 3
	)

	local pending_buttons = {}

	local row_index = 0
	local column_index = 0

	ItemVault_Data = {}

	for i, item in ipairs(data.items) do
		ItemVault_Data[item.id] = item.name

		row_index = math.floor((i - 1) / internal.MAX_COLUMN)
		column_index = (i - 1 - row_index * internal.MAX_COLUMN)

		local button = CreateFrame("Button", "ItemVault_ItemSlot" .. item.id, content, "ItemButtonTemplate")
		tinsert(item_slots, button)

		local offset_x = column_index * internal.ITEM_SLOT_WIDTH + internal.ITEM_SLOT_OFFSET_X
		local offset_y = internal.ITEM_SLOT_OFFSET_Y - row_index * internal.ITEM_SLOT_WIDTH

		button:SetPoint("TOPLEFT", content, "TOPLEFT", offset_x, offset_y)

		initializeItemButton(button, item)
	end
end

local function initialize()
	if internal.initialized then return end

	internal.initialized = true

	local window = CreateFrame("Frame", "ItemVault_Panel", UIParent, "UIPanelDialogTemplate")
	internal.window = window
	window:SetSize(530, 400)
	window:SetPoint("CENTER")
	window.title:SetText("Item Vault")

	makeFrameMovable(window)
	makeFrameCloseOnEscape(window)

	local scroll_frame = CreateFrame("ScrollFrame", "ItemVault_ScrollFrame", window, "UIPanelScrollFrameTemplate")
	internal.scrollFrame = scroll_frame

	scroll_frame:SetPoint("TOPLEFT", ItemVault_PanelDialogBG, "TOPLEFT", 3, -7)
	scroll_frame:SetPoint("BOTTOMRIGHT", ItemVault_PanelDialogBG, "BOTTOMRIGHT", -23, 2)

	local content = CreateFrame("Frame", nil, scroll_frame)
	internal.content = content

	internal.listAll()

	generateItemSlots()

	scroll_frame:SetScrollChild(content)
	scroll_frame:EnableMouse(true)
end
internal.initialize = initialize
