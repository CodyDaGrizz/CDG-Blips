local blips = {}

local function clearBlips()
    for _, blip in ipairs(blips) do
        if DoesBlipExist(blip) then
            RemoveBlip(blip)
        end
    end
    blips = {}
end

local function createBlip(data)
    if not data or not data.coords then return end

    local c = data.coords
    if type(c) == 'table' then
        c = vec3(c.x, c.y, c.z)
    end

    local blip = AddBlipForCoord(c.x, c.y, c.z)

    SetBlipSprite(blip, data.sprite or 1)
    SetBlipColour(blip, data.color or 0)
    SetBlipScale(blip, data.scale or 0.8)
    SetBlipAsShortRange(blip, data.shortRange ~= false)

    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(data.name or 'Blip')
    EndTextCommandSetBlipName(blip)

    blips[#blips + 1] = blip
end

CreateThread(function()
    for _, data in ipairs(Config.Blips) do
        createBlip(data)
    end
end)

-- Optional reload command (client-side)
RegisterCommand('reloadblips', function()
    clearBlips()
    for _, data in ipairs(Config.Blips) do
        createBlip(data)
    end
    print('[cdg_blips] Blips reloaded')
end, false)
