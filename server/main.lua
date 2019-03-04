ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_servicesradios:setWhoTalk')
AddEventHandler('esx_servicesradios:setWhoTalk', function(PlayerName, PlayerJob)
    local _source        = source
	local xPlayers 		 = ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer2 = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer2.job.name == PlayerJob then
			TriggerClientEvent("esx_servicesradios:setWhoTalkClient", _source, PlayerName, PlayerJob)
		end
	end
end)