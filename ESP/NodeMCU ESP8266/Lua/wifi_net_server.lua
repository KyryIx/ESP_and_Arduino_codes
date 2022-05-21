-------------------------------------------------
-- Code created by Everton Pereira da Cruz     --
-- To create Access Point with NodeMCU ESP8266 --
-- And control lamp using buttons              --
-- Test:
--  192.168.2.1?option=show    -> list info    --
--  192.168.2.1?option=turnon  -> turn on led  --
--  192.168.2.1?option=turnoff -> turn off led --
-------------------------------------------------

-- https://nodemcu.readthedocs.io/en/release/modules/wifi/
-- https://nodemcu.readthedocs.io/en/release/modules/wifi/#wifiap-module
-- https://nodemcu.readthedocs.io/en/release/modules/wifi/#wifiapconfig
-- https://nodemcu.readthedocs.io/en/release/modules/wifi/#wifiapsetip
-- https://nodemcu.readthedocs.io/en/release/modules/wifi/#wifisetphymode
-- https://nodemcu.readthedocs.io/en/release/modules/wifi/#wifisetmode
-- https://nodemcu.readthedocs.io/en/release/modules/net/#netcreateserver
-- https://nodemcu.readthedocs.io/en/release/modules/net/#netserverlisten
-- https://nodemcu.readthedocs.io/en/release/modules/net/#netsocketon

-- https://nodemcu.readthedocs.io/en/release/modules/net/#netsocketsend
-- https://nodemcu.readthedocs.io/en/release/modules/net/#netsocketclose

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
-- https://developer.mozilla.org/pt-BR/docs/Web/HTTP/Headers/Content-Type

cfg = {}
cfg.ssid = "NODE ESP8266"
cfg.pwd = "12345678912"
cfg.auth = wifi.WPA_PSK
cfg.channel = 6
cfg.hidden = false
cfg.max = 4
cfg.beacon = 100
cfg.save = false

if wifi.ap.config(cfg) then
	cfg = {}
	cfg.ip = "192.168.2.1"
	cfg.netmask = "255.255.255.0"
	cfg.gateway = "192.168.2.1"
	
	if wifi.ap.setip(cfg) then
		if wifi.setphymode( wifi.PHYMODE_B ) == wifi.PHYMODE_B then
			if wifi.setmode( wifi.SOFTAP, false ) == wifi.SOFTAP then
				print( "Soft Access Point and Server TCP started.\n" )
				
				local timeout = 30 -- seconds until disconnecting an inactive client
				sv = net.createServer( net.TCP, timeout )
				
				function receiver(sck, data)
					print( "-- receiver --" )
					if data == nil then
						print( "data empty" )
					else
						print( data )
						
						if string.sub(data,1,12) ~= "GET /?option" then
							print( "-- close by don't parameter option -- " )
							local response = {}
							response[#response + 1] = "You need to use: 192.168.2.1?option=show"
							response[#response + 1] = "or"
							response[#response + 1] = "You need to use: 192.168.2.1?option=turnon"
							response[#response + 1] = "or"
							response[#response + 1] = "You need to use: 192.168.2.1?option=turnon"
							
							local function send(sck)
								if #response > 0 then
									print( "-- sent --" )
									local text = table.remove(response, 1)
									print( "    response: " .. text )
									sck:send( text .. "\n" )
								else
									print( "-- close -- " )
									sck:close()
									response = nil
								end
							end
							
							sck:on( "sent", send )
							send(sck)
						
						else
							if string.sub(data,1,17) == "GET /?option=show" then
								local majorVer, minorVer, devVer, chipid, flashid, flashsize, flashmode, flashspeed = node.info()
								local response = {}
								response[#response + 1] = "CHIP ID: " .. node.chipid()
								response[#response + 1] = "NodeMCU "..majorVer.."."..minorVer.."."..devVer
								response[#response + 1] = "FLASH MODE: " .. flashmode 
								response[#response + 1] = "FLASH SPEED: " .. flashspeed .. " Hz"
								response[#response + 1] = "FLASH ID: " .. node.flashid()
								response[#response + 1] = "FLASH CHIP SIZE: " .. node.flashsize() .. " bytes"
								response[#response + 1] = "CURRENT CPU FREQUENCY: " .. node.getcpufreq() .. " MHz"
								response[#response + 1] = "CURRENT AVAILABLE HEAP SIZE: " .. node.heap() .. " bytes"
								
								local function send(sck)
									if #response > 0 then
										print( "-- sent --" )
										local text = table.remove(response, 1)
										print( "    response: " .. text )
										sck:send( text .. "\n" )
									else
										print( "-- close -- " )
										sck:close()
										response = nil
									end
								end
								
								sck:on( "sent", send )
								send(sck)
						
							else
								if string.sub(data,1,19) == "GET /?option=turnon" then
									local text = "turn on LED"
									
									local function send(sck)
										print( "-- sent --" )
										
										local ledPin = 4 -- GPIO2
										gpio.mode( ledPin, gpio.OUTPUT )
										gpio.write( ledPin, gpio.LOW )
										print( text )
										
										tmr.delay( 1000 )
										ledPin = nil
										text = nil
										
										sck:close()
									end
									
									sck:on( "sent", send )
									sck:send( text )
								
								else
									if string.sub(data,1,20) == "GET /?option=turnoff" then
										local text = "turn off LED"
									
										local function send(sck)
											print( "-- sent --" )
											
											local ledPin = 4 -- GPIO2
											gpio.mode( ledPin, gpio.OUTPUT )
											gpio.write( ledPin, gpio.HIGH )
											print( text )
											
											tmr.delay( 1000 )
											ledPin = nil
											text = nil
											
											sck:close()
										end
									
										sck:on( "sent", send )
										sck:send( text )
									
									else
										local function send(sck)
											print( "-- sent --" )
											print( "Unknow command." )
											sck:close()
										end
									
										sck:on( "sent", send )
										sck:send( "Unknow command." )
									end
								end
							end
						end
					end
				end
				
				if sv then
					local port = 80
					sv:listen( port, function(conn,data)
						conn:on( "receive", receiver )
					end)
				end
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