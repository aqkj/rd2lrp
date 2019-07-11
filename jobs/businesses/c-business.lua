-- * Class
local Jobs = class("Jobs", vRP.Extension)
Jobs.User = class("User")
Jobs.tunnel = {}

vRP:registerExtension(Jobs)

local offices = {
    ["job"] = {x = -258.60546875, y = -705.55871582032, z = 34.27241897583, name = "Employment Center", blip = 280, color = 5, marker = 27},
    ["business"] = {x = -156.09016418457, y = -603.548278808594, z = 48.2438659667969, name = "Business Center", blip = 431, color = 70, marker = 27},
}
local buildings = {}
local currentJob = "Unemployed"

local menuOpen = false

Citizen.CreateThread(
    function()
        print("Loading jobs...")
        initBlips(offices)

        while true do
            Citizen.Wait(1)
            local ped = GetPlayerPed(-1)
            for _, v in pairs(offices) do
                DrawMarker(v.marker, v.x, v.y, v.z - 1, 0, 0, 0, 0, 0, 0, 0.8, 0.8, 1.0, 55, 55, 255, 155, 0)
                local pos = GetEntityCoords(ped, true)
                local dist = Vdist(pos.x, pos.y, pos.z, v.x, v.y, v.z)
                if dist < 2.0 then
                    drawTxt(0.5, 0.8, 1.0, 1.0, 1.0, "~y~Select Job. ~p~H", 255, 255, 255, 255)
                    if IsControlJustPressed(0, 74) then
                        print("pressed")
                        vRPjobsS._openJobMenu(currentJob)
                        menuOpen = true
                    end
                elseif menuOpen then
                    vRPjobsS._closeJobsMenu()
                end
            end
        end
    end
)


-- * Job Tables

local banker = {}
banker['blips'] = {{x = 0.0, y = 0.0, z = 0.0, name = "Business Center", blip = 525, color = 5}}
function banker.constructor()
    for _, v in pairs(banker["blips"]) do
        initBlips(v)
    end
end


local realtor = {}
local insuranceSalesman = {}
local lawyer = {}
local judge = {}
local judicialAssistant = {}

local taxi = {}
function taxi.constructor()
    vRPjobsS._taxiConstruct()
end

function taxi.deconstructor()
    vRPjobsS._taxiDeconstruct()
end

local tow = {}
local chef = {}
local armsDealer = {}
local IT = {}
local pilot = {}
local drivingTeacher = {}
local carSalesman = {}
local carRepair = {}
local carExotic = {}
local company = {}

local jobs = {
    ["Realtor"] = realtor,
    ["Insurance Salesman"] = insuranceSalesman,
    ["Lawyer"] = lawyer,
    ["Judge"] = judge,
    ["Judicial Assistant"] = judicialAssistant,
    ["Banker"] = banker,
    ["Taxi"] = taxi,
    ["Tow"] = tow,
    ["Chef"] = chef,
    ["Arms Dealer"] = armsDealer,
    ["IT"] = IT,
    ["Pilot"] = pilot,
    ["Driving Teacher"] = drivingTeacher,
    ["Car Salesman"] = carSalesman,
    ["Car Repair"] = carRepair,
    ["Car Exotic"] = carExotic,
    ["Company"] = company
}

-- * Jobs Update Loop
Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(1)
            if not currentJob or not jobs[currentJob] or not jobs[currentJob].update() then
                return
            end
            jobs[currentJob].update()

        end
    end
)

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(1000 * 60 * 30) -- 30 minutes

            currentJob = vRPjobsS.getCurrentJob()

            if exports["cops"]:isEmergencyJob() then
                currentJob = "Emergency Worker"
            elseif not currentJob then
                currentJob = "Unemployed"
            end

            vRPjobsS._paycheck(currentJob)
        end
    end
)

RegisterCommand(
    "myjob",
    function(source, args, rawCommand)
        if exports["cops"]:isEmergencyJob() then
            currentJob = "Emergency Worker"
        elseif not currentJob then
            currentJob = "Unemployed"
        end
        TriggerEvent(
            "chat:addMessage",
            {
                color = {255, 255, 255},
                multiline = true,
                args = {"Your job is", currentJob}
            }
        )
    end,
    false
)

RegisterCommand(
    "setjob",
    function(source, args, rawCommand)
        local msg
        if exports["cops"]:isAdmin() then
            msg = "Setting job to " .. args[1]
            TriggerEvent("jobs:setCurrentJob", args[1])
        end
        TriggerEvent(
            "chat:addMessage",
            {
                color = {255, 255, 255},
                multiline = true,
                args = {msg}
            }
        )
    end,
    false
)

RegisterNetEvent("jobs:setCurrentJob")
AddEventHandler(
    "jobs:setCurrentJob",
    function(job)
        currentJob = job
    end
)

RegisterNetEvent("jobs:setJob")
AddEventHandler(
    "jobs:setJob",
    function(job)
        vRPjobsS._setCurrentJob(job)
        jobs[job].constructor()
    end
)

function drawTxt(x, y, width, height, scale, text, r, g, b, a)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width / 2, y - height / 2 + 0.005)
end