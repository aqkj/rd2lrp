local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","cars")
vRPCcars = Tunnel.getInterface("cars","cars")
async(function()
  vRP.loadScript("cars", "s-fuel")
end)