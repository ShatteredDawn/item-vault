local AbstractMigration = require("migration.abstract.abstract-migration")

local CreateDatabaseMigration = AbstractMigration:extend()

CreateDatabaseMigration.query = [[
    CREATE DATABASE IF NOT EXISTS `item_vault`
    DEFAULT CHARACTER SET utf8mb4
    COLLATE utf8mb4_general_ci;
]]

return CreateDatabaseMigration
