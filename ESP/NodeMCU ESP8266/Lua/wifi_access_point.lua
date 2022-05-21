-------------------------------------------------
-- Code created by Everton Pereira da Cruz     --
-- To create Access Point with NodeMCU ESP8266 --
-------------------------------------------------

-- https://nodemcu.readthedocs.io/en/release/modules/wifi/
-- https://nodemcu.readthedocs.io/en/release/modules/wifi/#wifiap-module
-- https://nodemcu.readthedocs.io/en/release/modules/wifi/#wifiapconfig
-- https://nodemcu.readthedocs.io/en/release/modules/wifi/#wifiapsetip
-- https://nodemcu.readthedocs.io/en/release/modules/wifi/#wifisetmode
-- https://nodemcu.readthedocs.io/en/release/modules/wifi/#wifisetphymode

-- https://nodemcu.readthedocs.io/en/release/modules/wifi/#wifiapgetconfig
-- https://nodemcu.readthedocs.io/en/release/modules/wifi/#wifistagetip
-- https://nodemcu.readthedocs.io/en/release/modules/wifi/#wifigetphymode
-- https://nodemcu.readthedocs.io/en/release/modules/wifi/#wifigetmode
-- https://nodemcu.readthedocs.io/en/release/modules/wifi/#wifiapgetmac

-- https://nodemcu.readthedocs.io/en/release/modules/node/#nodechipid
-- https://nodemcu.readthedocs.io/en/release/modules/node/#nodeinfo
-- https://nodemcu.readthedocs.io/en/release/modules/node/#nodeflashid
-- https://nodemcu.readthedocs.io/en/release/modules/node/#nodeflashsize
-- https://nodemcu.readthedocs.io/en/release/modules/node/#nodegetcpufreq
-- https://nodemcu.readthedocs.io/en/release/modules/node/#nodeheap

-- https://nodemcu.readthedocs.io/en/release/modules/tmr/#tmrcreate
-- https://nodemcu.readthedocs.io/en/release/modules/tmr/#tobjalarm
-- https://nodemcu.readthedocs.io/en/release/modules/wifi/#wifiapgetclient

-- view too
-- https://nodemcu.readthedocs.io/en/release/modules/node/
-- https://nodemcu.readthedocs.io/en/release/modules/wifi/#wifiapdhcp-module


function getStringAuthenticationMethod( method )
	if method == wifi.OPEN then
		return "wifi.OPEN"
	else if method == wifi.WPA_PSK then
		return "wifi.WPA_PSK"
	else if method == wifi.WPA2_PSK then
		return "wifi.WPA2_PSK"
	else if method == wifi.WPA_WPA2_PSK then
		return "wifi.WPA_WPA2_PSK"
	else
		return "unknow mode"
	end end end end
end

function getStringMode( mode )
	if mode == wifi.STATION then
		return "wifi.STATION"
	else if mode == wifi.SOFTAP then
		return "wifi.SOFTAP"
	else if mode == wifi.STATIONAP then
		return "wifi.STATIONAP"
	else if mode == wifi.NULLMODE then
		return "wifi.NULLMODE"
	else
		return "unknow mode"
	end end end end
end

function getStringPhysicalMode( mode )
	if mode == wifi.PHYMODE_B then
		return "wifi.PHYMODE_G (802.11g)"
	else if mode == wifi.PHYMODE_G then
		return "wifi.PHYMODE_G (802.11g)"
	else if mode == wifi.PHYMODE_N then
		return "wifi.PHYMODE_N (802.11n)"
	else
		return "unknow physical mode"
	end end end
end

global_password = "12345678912"
global_save = false

cfg_config = {}
cfg_config.ssid = "NODE ESP8266"
cfg_config.pwd = global_password
cfg_config.auth = wifi.WPA_PSK
cfg_config.channel = 6
cfg_config.hidden = false
cfg_config.max = 4
cfg_config.beacon = 100
cfg_config.save = global_save

cfg_ip = {}
cfg_ip.ip = "192.168.1.1"
cfg_ip.netmask = "255.255.255.0"
cfg_ip.gateway = "192.168.1.1"

mode = wifi.SOFTAP
physical_mode = wifi.PHYMODE_B

if wifi.ap.config(cfg_config) then
	print( "Successful in sets SSID and password in AP mode." )
	
	
	if wifi.ap.setip(cfg_ip) then
		print( "Successful in sets IP." )
		
		if wifi.setphymode( physical_mode ) == physical_mode then
			print( "Successful in sets physical mode (802.11b, 802.11g or 802.11n)." )
		
			if wifi.setmode( mode, global_save ) == mode then
				print( "Successful in sets mode (STATION, SOFTAP,STATIONAP or NULLMODE).\n" )
				print( "Soft AP started.\n" )
				
				local config_table = wifi.ap.getconfig( true )
				print( "SSID: " .. config_table.ssid )
				print( "PASSWORD: " .. global_password )
				print( "AUTHENTICATION METHOD: " .. getStringAuthenticationMethod(config_table.auth) )
				print( "CHANNEL: " .. config_table.channel )
				print( "HIDDEN: " .. tostring(config_table.hidden) )
				print( "MAX NUMBER CONNECTIONS: " .. config_table.max )
				print( "BEACON INTERVAL TIME: " .. config_table.beacon )
				print( "SAVED CONFIG: " .. tostring(global_save) .. "\n" )
				
				local ip, netmask, gateway = wifi.ap.getip()
				print( "IP: " .. ip )
				print( "NETMASK: " .. netmask )
				print( "GATEWAY: " .. gateway )
				print( "MAC: " .. wifi.ap.getmac() .. "\n" )
				
				print( "PHYSICAL MODE: " .. getStringPhysicalMode(wifi.getphymode()) )
				print( "MODE: " .. getStringMode(wifi.getmode()) .. "\n" )
				
				print( "CHIP ID: " .. node.chipid() )
				local majorVer, minorVer, devVer, chipid, flashid, flashsize, flashmode, flashspeed = node.info()
				print( "NodeMCU "..majorVer.."."..minorVer.."."..devVer )
				print( "FLASH MODE: " .. flashmode )
				print( "FLASH SPEED: " .. flashspeed .. " Hz" )
				print( "FLASH ID: " .. node.flashid() )
				print( "FLASH CHIP SIZE: " .. node.flashsize() .. " bytes" )
				print( "CURRENT CPU FREQUENCY: " .. node.getcpufreq() .. " MHz" )
				print( "CURRENT AVAILABLE HEAP SIZE: " .. node.heap() .. " bytes" )
				
				mytimer = tmr.create()
				mytimer:alarm( 5000, tmr.ALARM_AUTO, function()
					for mac,ip in pairs(wifi.ap.getclient()) do
						print( mac, ip )
					end
					print( "------" )
				end )
			else
				print( "Failure in sets mode (STATION, SOFTAP,STATIONAP or NULLMODE)." )
			end
			
		else
			print( "Failure in sets physical mode (802.11b, 802.11g or 802.11n).\n" )
		end
	
	else
		print( "Failure in setting IP" )
	end
	
else
	print( "Failure in sets SSID and password in AP mode." )
end