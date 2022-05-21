---------------------------------------------
-- Code created by Everton Pereira da Cruz --
-- Show networks using  NodeMCU ESP8266    --
---------------------------------------------

-- https://nodemcu.readthedocs.io/en/release/modules/wifi/#wifisetmode
-- https://nodemcu.readthedocs.io/en/release/modules/wifi/#wifistagetap
-- https://www.lua.org/pil/20.html

wifi.setmode( wifi.STATION )

cfg = {}
cfg.ssid = nil -- don't filter SSID
cfg.bssid = nil -- don't filter BSSID
cfg.channel = 0 -- scan all channels, otherwise scan set channel (default is 0)
cfg.how_hidden = 0 -- show_hidden == 1, get info for router with hidden SSID (default is 0)

format = 1 -- 0 : old format (SSID : Authmode, RSSI, BSSID, Channel),
           --     any duplicate SSIDs will be discarded
           -- 1 : new format (BSSID : SSID, RSSI, auth mode, Channel)
callback = function(table)
    if table then
        print( "\n\nVisible List Access Points:" )
        
        if format == 0 then
            -- SAMPLE OUTPUT
            -- Visible List Access Points:
            --     SSID                Authmode  RSSI  BSSID              Channel 
            --     #NET-CLARO-WIFI     0         -61   62:95:54:ad:81:7d  10
            --     xxxxxxx             4         -83   74:2d:63:7b:f7:14  6
            --     $3M $1N4L           4         -47   3c:fa:ba:5a:3a:18  6
            --     xxxxx               4         -75   1a:12:db:06:42:83  3
            --     xxxxxxxxxxxx        3         -61   10:9a:51:ee:f4:91  10
            --     xxxxxxxxx_2G        3         -91   14:3f:ef:3e:eb:e1  1
            --     xxxxxxxx2.4G        3         -88   a8:00:3a:64:b9:a8  4
            --     xxxxxx 2.4          4         -79   a4:a6:4c:81:2b:e2  1
            print( string.format("\t%-20s%-10s%-6s%-19s%-8s", 'SSID', 'Authmode', 'RSSI', 'BSSID', 'Channel' ) )
            for key,value in pairs(table) do
                local authmode, rssi, bssid, channel = string.match( value, "([^,]+),([^,]+),([^,]+),([^,]+)" )
                print( string.format("\t%-20s%-10s%-6s%-19s%-8s", key, authmode, rssi, bssid, channel) )
            end
        else
            -- SAMPLE OUTPUT
            -- Visible List Access Points:
            --     BSSID              SSID                RSSI  Authmode  Channel 
            --     1a:12:db:06:42:83  xxxxx               -75   4         3
            --     62:95:54:ad:81:7d  #NET-CLARO-WIFI     -61   0         10
            --     74:2d:63:7b:f7:14  xxxxxxx             -81   4         6
            --     10:9a:51:ee:f4:91  xxxxxxxxxxxx        -63   3         10
            --     a4:a6:4c:81:2b:e2  xxxxxx 2.4          -81   4         1
            --     5c:3a:3d:ac:b5:63  LUCAS               -70   4         3
            --     3c:fa:ba:5a:3a:18  $3M $1N4L           -46   4         6
            print( string.format("\t%-19s%-20s%-6s%-10s%-8s", 'BSSID', 'SSID', 'RSSI', 'Authmode', 'Channel' ) )
            for key,value in pairs(table) do
                local ssid, rssi, authmode, channel = string.match( value, "([^,]+),([^,]+),([^,]+),([^,]+)" )
                print( string.format("\t%-19s%-20s%-6s%-10s%-8s", key, ssid, rssi, authmode, channel) )
            end
        end
    else
        print( "Try again, please." )
    end
end

wifi.sta.getap( cfg, format, callback )