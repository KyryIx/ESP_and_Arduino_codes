---------------------------------------------
-- Code created by Everton Pereira da Cruz --
-- Blink LED BUILTIN in NodeMCU ESP8266    --
---------------------------------------------

-- https://nodemcu.readthedocs.io/en/release/modules/gpio/#gpiomode
-- https://nodemcu.readthedocs.io/en/release/modules/gpio/#gpiowrite
-- https://nodemcu.readthedocs.io/en/release/modules/tmr/#tmrcreate
-- https://nodemcu.readthedocs.io/en/release/modules/tmr/#tobjalarm
-- https://nodemcu.readthedocs.io/en/release/modules/gpio/#gpioread

ledPin = 4 -- GPIO2
gpio.mode( ledPin, gpio.OUTPUT )
gpio.write( ledPin, gpio.LOW )

mytimer = tmr.create()
mytimer:alarm( 1000, tmr.ALARM_AUTO, function()
    if gpio.read(ledPin) == gpio.LOW then
        gpio.write( ledPin, gpio.HIGH )
    else
        gpio.write( ledPin, gpio.LOW )
    end
end )