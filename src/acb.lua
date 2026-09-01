--- shit probably doesnt even work but ion care

-- loadstring(game:HttpGet("https://raw.githubusercontent.com/Pixeluted/adoniscries/main/Source.lua",true))()

setthreadidentity(3)

local protectedHookFunction = function(toHook, newFunction) 
    local ok, f = pcall(hookfunction(toHook, newFunction))

    if not ok or typeof(f) ~= "function" then
        return warn(`failed to hook {debug.info(toHook, "n")}`)
    end
end

local destroyHook; destroyHook = hookmetamethod(workspace, "__namecall", newcclosure(function(self, ...)
    if getnamecallmethod() == "Destroy" or getnamecallmethod() == "Clear" then
        return
    end

    return destroyHook(self, ...)
end))

local memoryFlood = filtergc("function", { Name = "FLOOD_MEMORY", IgnoreExecutor = true }, true)
local uniqueID = debug.getupvalue(memoryFlood, 1)

const newMemoryFlood = (function(...) return uniqueID end)
protectedHookFunction(memoryFlood, newMemoryFlood)

local detectionProxyFunction = filtergc("function", { Hash = "d8b9e99aeebbc83f5937f0d226b1a14de0d0aaeb516e8b7335d544ab06443178b5c20e360c3e42b9fd21e33bedcff11e", IgnoreExecutor = true }, true)
local detectionProxyBindableEventRef = debug.getupvalue(detectionProxyFunction, 1) -- ReplicatedStorage._sigma :3 (probably)

setstackhidden(detectionProxyFunction, true)

local oldBindable; oldBindable = hookmetamethod(detectionProxyBindableEventRef, "__namecall", newcclosure(function(self, ...) 
    if self == detectionProxyBindableEventRef then
        return
    end

    return oldBindable(self, ...)
end))

for _, s in getrunningscripts() do
    if s:GetFullName() == "Script" and s.ClassName == "Script" then
        local scriptClosure = getscriptclosure(s)
        protectedHookFunction(scriptClosure, function() return "lol" end)
    end
end

setthreadidentity(8)

print('acb ran')
