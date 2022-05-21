---------------------------------------------
-- Code created by Everton Pereira da Cruz --
-- Blink LED BUILTIN in NodeMCU ESP8266    --
---------------------------------------------

-- https://github.com/nodemcu/nodemcu-devkit-v1.0/blob/master/NODEMCU_DEVKIT_V1.0.PDF
-- https://www.esp8266.com/wiki/lib/exe/fetch.php?media=schematic_esp-12e.png
-- https://lowvoltage.github.io/2017/07/09/Onboard-LEDs-NodeMCU-Got-Two

-- https://nodemcu.readthedocs.io/en/release/modules/gpio/#gpiomode
-- https://nodemcu.readthedocs.io/en/release/modules/gpio/#gpiowrite
-- https://nodemcu.readthedocs.io/en/release/modules/gpio/#gpioread
-- https://nodemcu.readthedocs.io/en/release/modules/tmr/#tmrdelay

ledPin = 4 -- GPIO2
gpio.mode( ledPin, gpio.OUTPUT )

while 1 do
    gpio.write( ledPin, gpio.HIGH )
    tmr.delay( 1000000 )
    gpio.write( ledPin, gpio.LOW )
    tmr.delay( 1000000 )
end
