RegisterServerEvent('vrp_addons_gcphone:startCall')
AddEventHandler('vrp_addons_gcphone:startCall', function (number, message, coords)
  exports["vrp"]:CoreNotifyClient(source, "Request for "..number)
  exports["vrp"]:CoreSendServiceAlert(source, number,coords.x,coords.y,coords.z,message)
end)