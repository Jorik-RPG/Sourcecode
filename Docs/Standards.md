# Code Standard

## Casing
| Occurrence                 | Casing               |
| -------------------------- | -------------------- |
| Services                   | PascalCase           |
| Modules/Classes            | PascalCase           |
| Constants                  | SCREAMING_SNAKE_CASE |
| Local Variables            | camelCase            |
| Functions                  | camelCase            |
| Instance Variables         | PascalCase           |
| Private Instance Variables | _PascalCase          |

---
## Code layout
```Lua
-- SERVICES

-- MODULES

-- CONSTANTS

-- VARIABLES

-- FUNCTIONS

-- BODY
```
---
## Example Class
```Lua
-- SERVICES
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

-- MODULES
local Promise = require(script.Parent.Packages.Promise)

-- CONSTANTS

-- VARIABLES

-- FUNCTIONS

-- BODY
local Framework = {}
Framework.__index = Framework

function Framework.new(settings)
    settings = settings or error("Framework.new: Didn't provide settings argument")

    -- self definition
    local self = setmetatable({
        Roact = require(script.Parent.Packages.Roact),
        Local = ( settings.PathToLocal and settings.PathToLocal:GetDescendants() ) or error("Local modules path needed"),
        Shared = ( settings.PathToShared and settings.PathToShared:GetDescendants() ) or false,
        Packages = ( settings.PathToPackages and settings.PathToPackages:GetDescendants() ) or false,

        _Started = false
    }, Framework)

    self.Started = function()
        return Promise.fromEvent(runService.Heartbeat, function(resolve)
            return self._Started
        end)
    end

    self.Modules = require(script.Modules).new(self)
    self.Network = require(script.Network).new()
    self.Database = require(script.Database).new(self)

    self._Started = true

    return self
end

return Framework
```