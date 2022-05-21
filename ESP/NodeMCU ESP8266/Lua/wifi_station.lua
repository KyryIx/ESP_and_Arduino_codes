---------------------------------------------
-- Code created by Everton Pereira da Cruz --
-- Connect NodeMCU ESP8266 in page.php and --
-- record the data (state) of LED          --
---------------------------------------------

-- https://nodemcu.readthedocs.io/en/release/modules/wifi/#wifisetmode
-- https://nodemcu.readthedocs.io/en/release/modules/wifi/#wifistaconfig
-- https://nodemcu.readthedocs.io/en/release/modules/tmr/#tmrcreate
-- https://nodemcu.readthedocs.io/en/release/modules/tmr/#tobjalarm
-- https://nodemcu.readthedocs.io/en/release/modules/tmr/#tobjunregister
-- https://nodemcu.readthedocs.io/en/release/modules/tmr/#tobjstop
-- https://nodemcu.readthedocs.io/en/release/modules/gpio/#gpiomode
-- https://nodemcu.readthedocs.io/en/release/modules/gpio/#gpiotrig
-- https://nodemcu.readthedocs.io/en/release/modules/http/#httpget

ledPin = 4 -- GPIO2
buttonPin = 2 -- GPIO4

wifi.setmode( wifi.STATION )
station_cfg = {}
station_cfg.ssid = "YOUR_SSID"
station_cfg.pwd = "YOUR_PASSWORD"
wifi.sta.config( station_cfg )

function getStateButton(level, when)
	while gpio.read(buttonPin) == gpio.HIGH do
		tmr.delay( 10000 ) -- 10 ms
	end
	
	modifyState()
	sendState()
	
	if gpio.read(ledPin) ~= lastState then
		lastState = gpio.read(ledPin)
	end
end

function setings()
	gpio.mode( ledPin, gpio.OUTPUT )
	gpio.mode( buttonPin, gpio.INT )
	gpio.trig( buttonPin, "up", getStateButton )
	-- The LED in pin 4 work in invert logic
	-- If ledPin in gpio.HIGH, the LED is off
	-- But if ledPin in gpio.LOW, the LED is on
	gpio.write( ledPin, gpio.HIGH )
	lastState = gpio.HIGH
end

function modifyState()
    if gpio.read(ledPin) == gpio.LOW then
        gpio.write( ledPin, gpio.HIGH )
    else
        gpio.write( ledPin, gpio.LOW )
    end
end

function sendState()
    state = ""
    if gpio.read(ledPin) == gpio.HIGH then
        print( "LED OFF - GPIO2 HIGH" )
        state = "off"
    else
        print( "LED ON  - GPIO2 LOW" )
        state = "on"
    end

    url = "http://www.YOUR_HOST.com/wifi_station_insert.php?state="..state
    headers = nil
    http.get( url, headers, function(code, data)
        if code < 0 then
            print("HTTP request failed")
            print( '-----' )
        else
            print(code, data)
            print( url )
            print( '-----' )
        end
    end)
end

mytimer = tmr.create()
mytimer:alarm( 5000, tmr.ALARM_AUTO, function()
    print( "Try access..." )
    if wifi.sta.getip() ~= nil then
        print( "Access with success." )
        print( "Connected having IP " .. wifi.sta.getip() )

        mytimer:unregister()
        mytimer:stop()

        setings()
		sendState()
    end
end)