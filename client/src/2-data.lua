local _, internal = ...

local function appendData(extra_data)
	for _, item in ipairs(extra_data) do
		tinsert(internal.data.items, item)
	end
end
internal.appendData = appendData

internal.data = {
	categories = {
		[0] = "Miscellaneous",
		[171] = "Alchemy",
		[164] = "Blacksmithing",
		[185] = "Cooking",
		[333] = "Enchanting",
		[202] = "Engineering",
		[129] = "First Aid",
		[182] = "Herbalism",
		[773] = "Inscription",
		[755] = "Jewelcrafting",
		[165] = "Leatherworking",
		[186] = "Mining",
		[393] = "Skinning",
		[197] = "Tailoring",
	},
	items = {},
}
