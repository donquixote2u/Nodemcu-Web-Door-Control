-- ESP8266 webserver
-- This allows control of the door Entry/Exit latch
--  assumes valid internet connection active (wifi, ip address)
local Entryvalue = "ON"
local Exitvalue = "ON"
Log={}
function server()
    srv=net.createServer(net.TCP)
    srv:listen(80,function(conn)
    conn:on("receive",function(conn,payload)
    print(payload)  -- View the received data,
    --get control data from payload
    fnd = {string.find(payload,"Entry=")}
    if #fnd ~= 0 then 
        Entryvalue = string.sub(payload,fnd[2]+1) -- Data is at end already.
        if Entryvalue=="ON" then 
            Entrycolor="green"
        else  Entryvalue = "OFF"
             Entrycolor="red"
        end
    end -- Is there data in payload? - Take action if so.
    fnd = {string.find(payload,"Exit=")}
    if #fnd ~= 0 then 
        Exitvalue = string.sub(payload,fnd[2]+1) -- Data is at end already.
        if Exitvalue=="ON" then 
            Exitcolor="green"
        else  Exitvalue = "OFF"
             Exitcolor="red"
        end
    end -- Is there data in payload? - Take action if so.

    conn:send('<!DOCTYPE HTML>\n')
    conn:send('<html>\n')
    conn:send('<head><meta http-equiv="content-type" content="text/html; charset=UTF-8">\n')
    -- Scale the viewport to fit the device.
    conn:send('<meta name="viewport" content="width=device-width, initial-scale=1">')
    -- Title
    conn:send('<title>Cat Door Latch Control</title>\n')
    -- CSS style definition for submit buttons
    conn:send('<style>\n')
    conn:send('button[type="submit"] {\n')
    conn:send('color:#050; width:100px; padding:10px;\n')
    conn:send('font: bold 84% "trebuchet ms",helvetica,sans-serif;\n')
    conn:send('border:1px solid; border-radius: 12px;\n')
    conn:send('transition-duration: 0.4s;\n')
    conn:send('}\n')
    conn:send('button[type="submit"]:hover {\n')
    conn:send('color: white;\n')
    conn:send('}')
    conn:send('</style></head>\n')
    -- HTML body Page content.
    conn:send('<body>')
    conn:send('<h1>CAT DOOR STATUS</h1>')
        conn:send('<h3> (press to toggle status)</h3>')
   -- HTML Form (POST type) and buttons.  buttons trigger toggle from OFF to ON and vice versa
    conn:send('<form action="" method="POST">\n')
    conn:send('<button type="submit" name="Entry" ' )
    if Entryvalue=="ON" then
            conn:send('value="OFF" style="background-color:green" >ENTRY ENABLED</button><br><br>\n')
    else
            conn:send('value="ON" style="background-color:red" >ENTRY DISABLED</button><br><br>\n')
            print("#O")                      -- exit only
    end 
    conn:send('<button type="submit" name="Exit" ')        
    if Exitvalue=="ON" then
            conn:send('value="OFF" style="background-color:green" >EXIT ENABLED</button><br><br>\n')
    else
            conn:send('value="ON" style="background-color:red" >EXIT DISABLED</button><br><br>\n')
    end 
        buf="<p>"
        for k, v in pairs(Log) do
        buf=buf..v.."<br>"
        end
        buf=buf.."</p>"
        conn:send(buf);
    conn:send('</body></html>\n')
    conn:on("sent",function(conn) conn:close() end)
    end)
end)

end

