-- accept data via webserver GET, display on web and screen
--manifest: checkwifi.lua, screen.lua, webface.lua, webserverlua
--new manifest: screen.lua,connectIP.lua, ide.lua, wificredentials.lua
-- Constants
require("wificredentials")
-- Some control variables
wifiTrys     = 0      -- reset counter of trys to connect to wifi
NUMWIFITRYS  = 20    -- Maximum number of WIFI Testings while waiting for connection
require("WifiConnect")
function init_webserver()
dofile("ide.lua")
end
initTimeout=2000       -- // timer in ms
initTimer=tmr.create()  -- // start timer
initTimer:alarm(initTimeout,tmr.ALARM_SINGLE,function() checkConnection(init_webserver) end) 
