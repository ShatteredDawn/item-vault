local AbstractQuery = require("query.abstract.abstract-query")

local SelectAllStoredMaterialQuery = AbstractQuery:extend()

SelectAllStoredMaterialQuery.query = [[
    SELECT
        `item_template_id`, `quantity`
    FROM
        `item_vault`.`storage`
    WHERE
        `account_id` = :account_id
]]

return SelectAllStoredMaterialQuery
