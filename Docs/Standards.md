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
| Methods                    | PascalCase           |

---
## Code Layout/Template
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
---
## Example Framework Module

```Lua
return function(framework, ...)
    -- Required Framework Modules
    local Roact = framework.Roact
    local Network = framework.Network
    local Console = framework.Console.new(script)

    -- Registering events
    local exampleEvent = Network:GetEvent("Example")

    -- Connecting the example event
    local tempConnection = exampleEvent:Connect(function()
        Console:Print("Example event fired!")

        tempConnection:Disconnect()
    end)
end
```

## Example Framework Component

```Lua
local ExampleClass = {}
ExampleClass.__index = ExampleClass
ExampleClass.ClassName = "Example"

function ExampleClass.new()
    --- I guess we should just go with trix's method, if your going to set a metatable to the extendedfrom that'll just be worst indexing time.
  
    return setmetatable({
        _LocalInstance = false,
        _DylType = true
    }, ExtendedFrom.new())
   

   --[[
       class Example extends ExampleFramework {
           you can call everything defined in the ExampleFramework here.
           
       }
   ]]
end

-- Just like creating anyother class after that
```

## Example Class Using Framework

```Lua
--[[
    Framework should automatically be passed through the constructor, as should any other module you use. Otherwise this can lead to cylindrical requires.
]]
return function(framework)
    local Console = framework.Console.new("EXAMPLE?CLASS")

    local ExampleClass = {}
    ExampleClass.__index = ExampleClass
    ExampleClass.ClassName = "Example"

    function ExampleClass.new() -- why cant we just return the metatable here too?
        local self = setmetatable({
            _LocalInstance = false,
            _DylType = false,
        },ExampleClass)

        self:Initialize()
        self.Console:Debug("Example class is loaded")

        return self
    end

    function ExampleClass:Initialize()

    end

    return ExampleClass
end

-- Just like creating anyother class after that
```