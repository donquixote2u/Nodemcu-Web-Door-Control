-- ESP8266 webserver
-- This allows control of the door Entry/Exit latch
--  assumes valid internet connection active (wifi, ip address)
ENTRY = "ON"
EXIT = "ON"
SERIAL = "OFF"
DEBUG = "OFF"
function server()
    srv=net.createServer(net.TCP)
    srv:listen(80,function(conn)
    conn:on("receive",function(conn,payload)
    print("http req received\n")
    -- print(payload)  -- View the received data,
    html=header()				-- output html header/stylesheet
    conn:send(html)
	html=form()					-- html body + form header.
	html=html..button("ENTRY",ENTRY,payload)
	html=html..button("EXIT",EXIT,payload)
	html=html..button("SERIAL",SERIAL,payload)
	html=html..button("DEBUG",DEBUG,payload)
	conn:send(html)
	html=debugout()
	html=html..'</body></html>\n'
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
    txt=txt..'<style>\n'
    txt=txt..'button[type="submit"] {\n'
    txt=txt..'color:yellow; width:100px; padding:10px;\n'
    txt=txt..'font: bold 84% "trebuchet ms",helvetica,sans-serif;\n'
    txt=txt..'border:1px solid; border-radius: 12px;\n'
    txt=txt..'}\n'
    txt=txt..'button[type="submit"]:hover {\n'
    txt=txt..'color: white;\n'
    txt=txt..'}'
    txt=txt..'</style></head>\n'
    return txt
end
    
function form()
    local txt='<body>'
    txt=txt..'<h1>CAT DOOR STATUS</h1>'
    txt=txt..'<h3> (press to toggle status)</h3>'
    -- HTML Form (POST type) and buttons.  buttons trigger toggle from OFF to ON and vice versa
    txt=txt..'<form action="" method="POST">\n'
    return txt
end
    
function button(button_name,button_state,qrystring)
    local txt='<button type="submit" name="'..button_name..'" '
    -- search url to see if this button was pressed=changed
    local s,f = string.find(qrystring,button_name)
    if f ~= nil then -- this button has an associated action request
        button_state = string.sub(qrystring,f+2)  -- change button state to received value
        print("button "..button_name.." TURNED "..button_state)
        _G[button_name]=button_state
        _G["F"..button_name](button_state)  -- call action function for that button  
    end
    if button_state=="ON" then
        value="OFF"
       colour="green"
       state_desc="ENABLED"
    else
       value="ON"
       colour="red"
       state_desc="DISABLED"
    end
    txt=txt..' value="'..value..'" style="background-color:'..colour..'" >'..button_name..' '..state_desc..'</button><br><br>\n'      
    -- print("#O")                     
    txt=txt..'</button><br><br>\n'
    return txt  
end
    
function debugout()
    local txt="<p>"
    if(DEBUG=="ON") then
       for k, v in pairs(Log) do
        txt=txt..v.."<br>"
        end
        txt=txt.."</p>"
     end   
        return txt
end

function FENTRY(state)
    if (state=="ON") then
       if(EXIT=="ON") then print("#B") else print("#I") end
    else
       if(EXIT=="ON") then print("#O") else print("#L") end
    end 
end

function FEXIT(state)
end

function FSERIAL(state)
    if (state=="ON") then
       serTimer:alarm(serinitTimeout,tmr.ALARM_SINGLE,function() serialon() end) 
    else
        uart.on("data") -- unregister callback
        -- serTimer:alarm(serinitTimeout,tmr.ALARM_SINGLE,function() node.restart() end) 
    end 
end

-- configure for 115200, 8N1, with echo
function serialon()
uart.setup(0, 115200, 8, uart.PARITY_NONE, uart.STOPBITS_1, 1)
uart.on("data", "\r",
  function(data)
    if(#Log>Loglim) then
      table.remove(Log,1)
    end
    table.insert(Log,data)  
    end, 0)
end 

function FDEBUG(state)
end
