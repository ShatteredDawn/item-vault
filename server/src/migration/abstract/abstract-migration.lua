local Extendable = require("utility.extendable")
local AbstractMigration = Extendable:extend()

AbstractMigration.query = "SHOW TABLES"

function AbstractMigration:execute()
	CharDBExecute(self.query)
end

return AbstractMigration
