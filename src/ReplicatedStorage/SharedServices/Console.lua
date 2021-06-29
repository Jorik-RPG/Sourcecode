--@@ Author Trix

--Services
local RunService = game:GetService("RunService")

--
local isStudio = RunService:IsStudio()
local isServer = RunService:IsServer() or (isStudio and not RunService:IsRunning())
local hostname = isServer and "SERVER" or "CLIENT"

--
local function FlattenMessage(...)
	local message = ""

	for _, str in ipairs{...} do
		message = message.." "..str
	end

	return message
end

--
local Console = {
	Name = "Console";	
} do
	Console.__index = Console
	Console.__newindex = function(t, i, v)
		error("Invalid data type for 'index';")
	end

	function Console.new(scope)
		scope = type(scope) == "string" and scope or error("Invalid data type for 'scope'; a string is expected")

		return setmetatable({
			Scope = string.upper(scope)	
		}, Console)
	end

	function Console:Assert(value, errorMessage)
		if value == false or value == nil then self:Error(errorMessage, 2) end

		return value
	end

	function Console:Debug(...)
		if isStudio then
			local message = FlattenMessage("["..hostname.."]["..self.Scope.."][DEBUG]:", ...)

			print(message)
		end
	end

	function Console:Log(...)
		local message = FlattenMessage("["..hostname.."]["..self.Scope.."][INFO]:", ...)

		print(message)
	end

	function Console:Warn(...)
		local message = FlattenMessage("["..hostname.."]["..self.Scope.."][WARN]:", ...)

		warn(message)
	end

	function Console:Error(message, printIdentity)
		error("["..hostname.."]["..self.Scope.."][ERROR]: "..tostring(message), (printIdentity or 1) + 1)
	end
end

return Console