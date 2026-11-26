-- Choo-Choo co-op: discovery pass (Phase 3)
-- Runs on UE4SS start; logs the classes we will need to replicate.

local LOG = function(s) print("[choo-coop] " .. s) end

local WATCH_PREFIXES = {
    BP_PlayerCharacter, BP_Train, BP_Charles,
}

RegisterHook("/Script/Engine.PlayerController:ClientRestart", function(Context)
    local world = Context:get():GetWorld()
    if world then
        LOG("map loaded: " .. tostring(world:GetFName():ToString()))
    end
end)

-- Dump BP classes once the first map is live
local dumped = false
LoopAsync(5000, function()
    if dumped then return true end
    for _, cls in pairs(WATCH_PREFIXES) do
        if cls ~= nil then dumped = true end
    end
    return false
end)

LOG("discovery mod loaded")
