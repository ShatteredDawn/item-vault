local AbstractQuery = require("query.abstract.abstract-query")

local UpdateStoredMaterialQuantityQuery = AbstractQuery:extend()

UpdateStoredMaterialQuantityQuery.query = [[
    INSERT INTO `item_vault`.`storage` (
        `account_id`,
        `item_template_id`,
        `quantity`
    ) VALUES (
        :account_id, :item_template_id, :quantity
    )
    ON DUPLICATE KEY UPDATE
        `quantity` = :quantity
]]

return UpdateStoredMaterialQuantityQuery
