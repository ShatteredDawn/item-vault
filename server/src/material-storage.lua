local CreateDatabaseMigration = require("migration.initial.database.create-database-migration")
local CreateStorageTableMigration = require("migration.initial.table.create-storage-table-migration")
local ServerResponsesConfiguration = require("server-message-handler.configuration")

local MaterialStorage = {}

function MaterialStorage:new()
    local instance = {}

    setmetatable(instance, { __index = MaterialStorage })

    return instance
end

function MaterialStorage:initializeDatabase()
    PrintError("Initializing Material Storage database...")

    CreateDatabaseMigration:execute()
    PrintError("Database created or already exists.")
    PrintError("Creating storage table...")
    CreateStorageTableMigration:execute()
    PrintError("Storage table created or already exists.")
end

function MaterialStorage:initializeServerMessageHandlers()
    PrintError("Initializing Material Storage server message handlers...")

    RegisterClientRequests(ServerResponsesConfiguration)

    PrintError("Server message handlers initialized.")
end

function MaterialStorage:start()
    self:initializeDatabase()
    self:initializeServerMessageHandlers()
end

return MaterialStorage
