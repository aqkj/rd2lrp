vRPRob = {}
Tunnel.bindInterface("robberies", vRPRob)
Proxy.addInterface("robberies", vRPRob)
vRPclient = Tunnel.getInterface("vRP","robberiesC")
vRProbC = Tunnel.getInterface("robberiesC","robberiesC")

local BASE_STORE_ROB_MONEY = 10
local CONST_BASE_BANK_ROB_MONEY = 1000

function vRPRob.robMoney(victimId)
    print("money")
    local user = vRP.users_by_source[source]
    local victim = vRP.users_by_source[victimId]

    local wallet = victim:getWallet()
    victim:tryPayment(wallet, false)

    user:giveWallet(wallet)

    vRP.EXT.Base.remote._notify(user.source, "You stole "..wallet.."$")
    vRP.EXT.Base.remote._notify(victim.source, "You were robbed")
end

function vRPRob.robInventory(victimId)
    print("invs")
    local user = vRP.users_by_source[source]
    local victim = vRP.users_by_source[victimId]

    user:openChest(victim.source, 30)
end

function vRPRob.robStore()
    local user = vRP.users_by_source[source]
    print(user.source)
    math.randomseed(os.time())
    local randomMoney = math.random(25, 322)
    local amount = BASE_STORE_ROB_MONEY + randomMoney
    user:giveWallet(amount)
    TriggerClientEvent("pNotify:SendNotification", user.source, {
        text = "<p>You robbed the store for "..amount.."$!</p>",
        type = "success",
        timeout = 5000,
        layout = "topRight"
    })
end

function vRPRob.robStoreCooldown(id)
    vRProbC.setStoreCooldown(-1, id)
end

function vRPRob.robBankCooldown(name)
    vRProbC.setBankCooldown(-1, name)
end

function vRPRob.takeThermite()
    local user = vRP.users_by_source[source]
    if (user:tryTakeItem("thermite", 1, false, false)) then
        return true
    end
    return false
end

function vRPRob.robBank()
    local user = vRP.users_by_source[source]
    math.randomseed(os.time())
    local rand1 = math.random(500, 1750)
    local rand2 = math.random(750, 1000)
    local amount = CONST_BASE_BANK_ROB_MONEY + rand1 + rand2
    user:giveWallet(amount)
    TriggerClientEvent("pNotify:SendNotification", user.source, {
        text = "<p>You robbed the bank for "..amount.."$!</p>",
        type = "success",
        timeout = 5000,
        layout = "topRight"
    })
end

function vRPRob.robPed()
    local user = vRP.users_by_source[source]
    math.randomseed(os.time())
    local amount = math.random(5, 60)
    user:giveWallet(amount)
    vRP.EXT.Base.remote._notify(user.source, "You stole "..amount.."$.")
end