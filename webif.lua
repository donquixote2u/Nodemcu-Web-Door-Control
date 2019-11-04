-- version 2 of webserver; accepts any GET var, displays
function init_webserver()
PAGETITLE="ESP8266 Web Server"
print("starting webserver") 
srv=net.createServer(net.TCP)
srv:listen(80,function(conn)
    conn:on("receive", function(client,request)
    local buf= "<h1>"..PAGETITLE.."</h1>"
    getVars(client,request)
    for k, v in pairs(_GET) do
		buf = buf.."<p>"..k.." : "..v.."</p>"
    end
   print("buffer="..buf) 
   client:send(buf)
   -- client:close()
   collectgarbage()
   end)
end)
end
--    ==================================================
-- EXTRACT GET VARS FROM WEB REQUEST
function getVars(client,request)
local _, _, method, path, vars = string.find(request, "([A-Z]+) (.+)?(.+) HTTP");
    if(method == nil)then
    _, _, method, path = string.find(request, "([A-Z]+) (.+) HTTP");
    end
    if (vars ~= nil)then
    for k,v in string.gmatch(vars, '([^&=?]-)=([^&=?]+)' ) do
    -- for k, v in string.gmatch(vars, "(%w.+)=(%w.+)&*") do
        _GET[k] = v
        print("k="..k..";v="..v)
        end
    end    
end 

-- STARTS HERE --
print("webalerter started")
_GET={} -- GET params received by web server OR 
require("WifiConnect")
wifiTrys     = 0      -- reset counter of trys to connect to wifi
NUMWIFITRYS  = 20    -- Maximum number of WIFI Testings while waiting for connection
initTimeout=2000       -- // timer in ms
initTimer:alarm(initTimeout,tmr.ALARM_SINGLE,function() checkConnection(init_webserver) end) 
