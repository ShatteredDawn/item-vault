local CreateDatabaseMigration = require("migration.initial.database.create-database-migration")
local CreateStorageTableMigration = require("migration.initial.table.create-storage-table-migration")
local ServerResponsesConfiguration = require("server-message-handler.configuration")

local ItemVault = {}

function ItemVault:new()
    local instance = {}

    setmetatable(instance, { __index = ItemVault })

    return instance
end

function ItemVault:initializeDatabase()
    PrintDebug("Initializing Material Storage database...")

    CreateDatabaseMigration:execute()
    PrintDebug("Database created or already exists.")
    PrintDebug("Creating storage table...")
    CreateStorageTableMigration:execute()
    PrintDebug("Storage table created or already exists.")
end

function ItemVault:initializeServerMessageHandlers()
    PrintDebug("Initializing Material Storage server message handlers...")

    RegisterClientRequests(ServerResponsesConfiguration)

    PrintDebug("Server message handlers initialized.")
end

function ItemVault:start()
    self:initializeDatabase()
    self:initializeServerMessageHandlers()
end

return ItemVault
