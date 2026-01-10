local AbstractQuery = require("query.abstract.abstract-query")

local SelectStoredMaterialQuantityQuery = AbstractQuery:extend()

SelectStoredMaterialQuantityQuery.query = [[
    SELECT `quantity`
    FROM `material_storage`.`storage`
    WHERE `account_id` = :account_id AND `item_template_id` = :item_template_id
]]

return SelectStoredMaterialQuantityQuery
