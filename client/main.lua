ESX						= nil
local PlayerData		= {}
local Keys				= {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	Citizen.Wait(1000)
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

local voice = {default = 2.5, shout = 12.0, whisper = 1.0, current = 0, level = nil}
-- 12.0 shout

RegisterNetEvent('esx_servicesradios:setWhoTalkClient')
	AddEventHandler('esx_servicesradios:setWhoTalkClient', function(PlayerNames, PlayerJob)
	i = 0
	while true do
		if i < 150 then
			drawWhoTalk(PlayerNames, PlayerJob, 41, 128, 185, 255)
			i = i+1
		else
			break
		end
		Citizen.Wait(5)
	end
end)


function drawLevel(joblabel, r, g, b, a)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextScale(0.5, 0.5)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	BeginTextCommandDisplayText("STRING")
	AddTextComponentSubstringPlayerName(_U('title', joblabel).._U('title_2', voice.level))
	EndTextCommandDisplayText(0.786, 0.936)
end

function drawWhoTalk(who, PlayerJob, r, g, b, a)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextScale(0.5, 0.5)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	BeginTextCommandDisplayText("STRING")
	AddTextComponentSubstringPlayerName(_U('who_talk', who))
	EndTextCommandDisplayText(0.786, 0.966)
end

Citizen.CreateThread(function()
	while true do
		for k, v in pairs(Config.Networks) do
			network = Config.Networks[k]
			if PlayerData.job ~= nil and PlayerData.job.name == network.jobname then
				if IsControlJustPressed(1, Keys['L']) and IsControlPressed(1, Keys['LEFTSHIFT']) then
					voice.current = (voice.current + 1) % 3
					if voice.current == 0 then
						Citizen.InvokeNative(0xE036A705F989E049)
						NetworkSetTalkerProximity(voice.default)
						voice.level = _U('no_network')
					elseif voice.current == 1 then
						NetworkSetVoiceChannel(network.NetworkId)
						NetworkSetTalkerProximity(voice.default)
						voice.level = _U('network')
					end
				end

				if voice.current == 0 then
					voice.level = _U('no_network')
				elseif voice.current == 1 then
					voice.level = _U('network')
				end

				if NetworkIsPlayerTalking(PlayerId()) then
					if voice.current ~= 0 then
						TriggerServerEvent('esx_servicesradios:setWhoTalk', GetPlayerName(GetPlayerIndex()), network.jobname)
						drawLevel(network.joblabel, 41, 128, 185, 255)
					else
						drawLevel(network.joblabel, 185, 185, 185, 255)
					end
				elseif not NetworkIsPlayerTalking(PlayerId()) then		
					drawLevel(network.joblabel, 185, 185, 185, 255)
				end
			end
		end
		Citizen.Wait(5)
	end
end)