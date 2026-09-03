--- shit probably doesnt even work but ion care

getgenv().adonisBypass = false

const function notify(text, duration)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "deadend.cc",
        Text = text,
        Duration = duration
    })
end

local oldDestroy; oldDestroy = hookmetamethod(game, "__index", newcclosure(function(self, key)
    if key == "Destroy" or key == "Clear" then
        return
    end

    return oldDestroy(self, key)
end))

const yieldFunction = (function(...) while true do wait(0xFF) end end)
const newDetectionProxyFunction = (function() while true do wait(0xFF) end return "" end)

local checkStackFunction = filtergc("function", { Hash = "801b76891f73d63ec073100922d1d5bde4af00e0ad4d891f096224f94370c40a5bc12f70eacf69530f199d4f000da8d0", IgnoreExecutor = true }, true)
local detectionProxyFunction = filtergc("function", { Hash = "d8b9e99aeebbc83f5937f0d226b1a14de0d0aaeb516e8b7335d544ab06443178b5c20e360c3e42b9fd21e33bedcff11e", IgnoreExecutor = true }, true)
local memoryFloodFunction = filtergc("function", { Name = "FLOOD_MEMORY", IgnoreExecutor = true }, true)
local metamethodChecksFunction = filtergc("function", { Hash = "98ead62c64aabce7b4d7780be90367a521c3863717110f4251875fe873804bd6e294990723a8be90c4386d2cb33cd855", IgnoreExecutor = true }, true)

hookfunction(checkStackFunction, yieldFunction)
hookfunction(detectionProxyFunction, newDetectionProxyFunction)
hookfunction(metamethodChecksFunction, yieldFunction)

local bindableEvent = debug.getupvalue(detectionProxyFunction, 1) -- ReplicatedStorage._sigma :3 (probably)

local oldTaskSpawn; oldTaskSpawn = hookfunction(task.spawn, function(...)  
    if checkcaller() then return oldTaskSpawn(...) end
    
    local arg1 = select(1, ...)
    if rawequal(typeof(arg1), "function") and rawequal(arg1, memoryFloodFunction) then
        return
    end

    return oldTaskSpawn(...)
end)

local infoFunction = debug.info
local oldInfo; oldInfo = hookfunction(infoFunction, newcclosure(function(level, options)
    if checkcaller() then return oldInfo(level, options) end
    if typeof(level) ~= "number" then return oldInfo(level, options) end

    if typeof(level) == "number" and level >= 0 and level <= 20 then
        if options == "l" then
            return nil
        end
    end

    return oldInfo(level, options)
end))

local oldNamecall; oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local method = getnamecallmethod()
    
    if method == "Fire" or method == "fire" then
        if self == detectionProxyBindableEvent then
            return
        end
        
        local arg1 = select(1, ...)
        if typeof(arg1) == "table" then
            for key, _ in arg1 do
                if typeof(key) == "userdata" then
                    return
                end
            end
        end
    end

    return oldNamecall(self, ...)
end))

local bypassSuccess = false
task.spawn(function()
    local thread2
    local thread = task.spawn(function() 
        game:GetService("Players").LocalPlayer.PlayerGui.ChildAdded:Connect(function(inst) 
            local name = tostring(inst.Name)
            if name:lower():find("terminal") then
                repeat task.wait() inst:Destroy() until not inst
                return
            end
        end)
        thread2 = task.spawn(function()
            while task.wait(0.5) do -- unoptimized but fuck you
                for _, func in filtergc("function", {}) do
                    local s = debug.info(func, "s")
                    if not tostring(s):lower():find("crash") then continue end
                    local o; o = hookfunction(func, function(...)
                        error()
                    end)
                end
            end
        end)
        if adonisBypass then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaomao8090/Adonis-Bypass-Framework/master/AdonisBypass.lua"), "adonis bypass")()
        end
        bypassSuccess = true
    end); task.wait(10); task.cancel(thread); task.cancel(thread2);
end)

notify("pwning anticheat hold up", 5)
repeat wait() until bypassSuccess
notify("ok done have fun", 5)
notify("also u might lag in a sec jus wait", 5)

return bypassSuccess
