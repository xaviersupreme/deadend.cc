--- shit probably doesnt even work but ion care

loadstring(game:HttpGet("https://raw.githubusercontent.com/Pixeluted/adoniscries/main/Source.lua",true))()

setthreadidentity(3)

local oldDestroy; oldDestroy = hookmetamethod(game, "__index", newcclosure(function(self, key)
    if key == "Destroy" or key == "Clear" then
        return
    end

    return oldDestroy(self, key)
end))

local checkStackFunction = filtergc("function", { Hash = "801b76891f73d63ec073100922d1d5bde4af00e0ad4d891f096224f94370c40a5bc12f70eacf69530f199d4f000da8d0", IgnoreExecutor = true }, true)
local newCheckStackFunction = function(...) end
hookfunction(checkStackFunction, newCheckStackFunction)

local detectionProxyFunction = filtergc("function", { Hash = "d8b9e99aeebbc83f5937f0d226b1a14de0d0aaeb516e8b7335d544ab06443178b5c20e360c3e42b9fd21e33bedcff11e", IgnoreExecutor = true }, true)
local newDetectionProxyFunction = function() return "" end
hookfunction(detectionProxyFunction, newDetectionProxyFunction)

local bindableEvent = debug.getupvalue(detectionProxyFunction, 1) -- ReplicatedStorage._sigma :3 (probably)

local infoFunction = debug.info
local oldInfo; oldInfo = hookfunction(infoFunction, newcclosure(function(level, options)
    if checkcaller() then return oldInfo(level, options) end
    if typeof(level) ~= "number" then return oldInfo(level, options) end

    if typeof(level) == "number" and number >= 0 and number <= 20 then
        if options == "l" then
            return nil
        end
    end

    return oldInfo(level, options)
end))

local oldBindable; oldBindable = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if self == detectionProxyBindableEvent and (method == "Fire" or method == "fire") then
        return
    end

    return oldBindable(self, ...)
end))

local oldProxyCaller; oldProxyCaller = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    if (method == "Fire" or method == "fire") and typeof(args[1]) == "table" then
        for key, _ in args[1] do
            if typeof(key) == "userdata" then
                return
            end
        end
    end

    return oldProxyCaller(self, ...)
end))

-- local memoryFlood = filtergc("function", { Name = "FLOOD_MEMORY", IgnoreExecutor = true }, true)
-- local newMemoryFlood = (function(p1) if p1 ~= nil then return uniqueID end end)/
-- local uniqueID = debug.getupvalue(memoryFlood, 1)
-- hookfunction(memoryFlood, newMemoryFlood)
-- print("hooked memoryFlood")

local oldTableCreate; oldTableCreate = hookfunction(table.create, newcclosure(function(size, ...) 
    if size > 1_000 then return {} end
    return oldTableCreate(size, ...)
end))

local oldBufferCreate; oldBufferCreate = hookfunction(buffer.create, newcclosure(function(size) 
    if size > 10_000 then return oldBufferCreate(0) end
    return oldBufferCreate(size)
end))

setthreadidentity(8)

print('acb ran')
