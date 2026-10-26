if UnlimitedPvE and UnlimitedPvE._base_resource_min == nil then
    UnlimitedPvE._base_resource_min = UnlimitedPvE.resource_min
    UnlimitedPvE._base_resource_max = UnlimitedPvE.resource_max
    if type(UnlimitedPvE.wave) == "table" then
        UnlimitedPvE.wave._base_resource_min = UnlimitedPvE.wave.resource_min
        UnlimitedPvE.wave._base_resource_max = UnlimitedPvE.wave.resource_max
    end
end

function UnlimitedPvE.ApplyCreditRate()
    local rate = 1
    if cvars ~= nil and type(cvars.rate_cred) == "string" then
        local n = tonumber(string.match(cvars.rate_cred, "^%s*([^,]+)"))
        if n and n > 0 then
            rate = n
        end
    end
    UnlimitedPvE.resource_min = UnlimitedPvE._base_resource_min * rate
    UnlimitedPvE.resource_max = UnlimitedPvE._base_resource_max * rate
    if type(UnlimitedPvE.wave) == "table" then
        UnlimitedPvE.wave.resource_min = UnlimitedPvE.wave._base_resource_min * rate
        UnlimitedPvE.wave.resource_max = UnlimitedPvE.wave._base_resource_max * rate
    end
end

local function PvE_WrapInsigniaRate(fn)
    return function(self, ...)
        UnlimitedPvE.ApplyCreditRate()
        if fn then
            return fn(self, ...)
        end
    end
end

if PvE_Missions then
    for _, mission in pairs(PvE_Missions) do
        if type(mission) == "table" then
            mission.SV_OnStart = PvE_WrapInsigniaRate(mission.SV_OnStart)
            if type(mission.rounds) == "table" then
                for _, round in pairs(mission.rounds) do
                    if type(round) == "table" then
                        round.SV_OnStartRound = PvE_WrapInsigniaRate(round.SV_OnStartRound)
                    end
                end
            end
        end
    end
end
