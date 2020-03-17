-- ESP8266 webserver
-- This allows control of the door Entry/Exit latch
--  assumes valid internet connection active (wifi, ip address)
ENTRY = "ON"
EXIT = "ON"
DEBUG = "ON"
function server()
    srv=net.createServer(net.TCP)
    srv:listen(80,function(conn)
    conn:on("receive",function(conn,payload)
    -- DEBUG print("http req received\n")
    -- DEBUG print(payload)  -- View the received data,
    local s,f = string.find(payload,'command')
    if f ~= nil then -- this button has an associated action request
        command=string.sub(payload,f+2)  -- get button state received value
        -- print("cmd is:"..command)
        FPRINT("#"..command)
        -- _G[button_name]=button_state        -- set button to received value
        -- _G["F"..button_name](button_state)  -- call action function for that button  
    end
    html=header()				-- output html header/stylesheet
	html=html..form()					-- html body + form header.
	html=html.."<input type='text' size='2' name='command'><br>"
	html=html.."</form>"
	html=html..'</div><div id="debug"><code>'..debugout()  -- blank unless debug on
	html=html..'</code></div></body></html>\n'
    conn:send(html)
    conn:on("sent",function(conn) conn:close() end)
    end)
end)
end

function header()
    local txt='<!DOCTYPE HTML>\n'
    txt=txt..'<html>\n'
    txt=txt..'<head><meta http-equiv="content-type" content="text/html; charset=UTF-8">\n'
    -- Scale the viewport to fit the device.
    txt=txt..'<meta name="viewport" content="width=device-width, initial-scale=1">'
    txt=txt..'<title>Cat Door Latch Control</title>\n'
    -- CSS style definition for submit buttons
    txt=txt.."<link href='http://192.168.0.2/WebUI/css/bootstrap.css' rel='stylesheet' type='text/css' />\n"
    txt=txt..'<style>\n'
    txt=txt..'</style></head>\n'
    return txt
end
    
function form()
    local txt='<body>'
    txt=txt..'<h1>CAT DOOR STATUS</h1><div id="form">'
    txt=txt..'<form action="" method="POST">\n'
    return txt
end
    
function debugout()
    local txt="<p>"
    if(DEBUG=="ON") then
       for k, v in pairs(Log) do
        txt=txt..k..":"..v.."<br>"
        end
        txt=txt.."</p>"
     end   
        return txt
end

function FPRINT(txt)
    uart.write(0,txt)
    table.insert(Log,1,txt)
    if(#Log>Loglim) then
      table.remove(Log,Loglim)
    end
end

function FENTRY(state)
    if (state=="ON") then
       if(EXIT=="ON") then FPRINT("#B") else FPRINT("#I") end
    else
       if(EXIT=="ON") then FPRINT("#O") else FPRINT("#L") end
    end 
end

function FEXIT(state)
end

function FDEBUG(state)
end

function FSERIAL(state)
    if (state=="ON") then
       serTimer:alarm(serinitTimeout,tmr.ALARM_SINGLE,function() serialon() end) 
    else
        uart.on("data") -- unregister callback
        -- serTimer:alarm(serinitTimeout,tmr.ALARM_SINGLE,function() node.restart() end) 
    end 
end

-- comms line to door control: configure for 115200, 8N1, with echo
function serialon()
uart.setup(0, 115200, 8, uart.PARITY_NONE, uart.STOPBITS_1, 1)
uart.on("data", "\n",
  function(data)
    table.insert(Log,1,data)
    if(#Log>Loglim) then
      table.remove(Log,Loglim)
    end
    local s,f=string.find(data,"*DO")
    if(f~=nil) then
       alert=string.sub(data,s+1,s+3) -- isolate alert code
       print("alert called:"..alert.."\n")
       initTimer:alarm(initTimeout,tmr.ALARM_SINGLE,function() sendAlert(alert) end) 
    end   
    end, 0)
end 

function sendAlert(alert_type)
-- require("webclient1")
require("httpclient")
initTimer:alarm(initTimeout,tmr.ALARM_SINGLE,function() sendPhone(alert_type) end) 
end

function sendPhone(alert_type)
-- setServer("IP","104.27.148.113") -- set address
-- setServer("SUBDIR","") -- set dir
-- REQ=""
REQ="http://wirepusher.com/send?id=wAptmpnzh&title=Alert&message=Cat&type=Cat"
sendReq()
end
