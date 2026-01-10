local AbstractMigration = require("migration.abstract.abstract-migration")

local CreateStorageTableMigration = AbstractMigration:extend()

CreateStorageTableMigration.query = [[
    CREATE TABLE IF NOT EXISTS `material_storage`.`storage` (
        `account_id` INT(32) UNSIGNED NOT NULL,
        `item_template_id` INT(32) UNSIGNED NOT NULL,
        `quantity` INT(32) UNSIGNED NOT NULL,
        PRIMARY KEY (`account_id`, `item_template_id`)
    )
]]

return CreateStorageTableMigration
