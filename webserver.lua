-- ESP8266 webserver
-- This allows control of the door Entry/Exit latch
--  assumes valid internet connection active (wifi, ip address)
local Entrystate = "ON"
local Exitstate = "ON"

function server()
srv=net.createServer(net.TCP)
    srv:listen(80,function(conn)
    conn:on("receive",function(conn,payload)
    print(payload)  -- View the received data,
    --get control data from payload
    fnd = {string.find(payload,"Entry=")}
    if #fnd ~= 0 then 
        Entrystate = string.sub(payload,fnd[2]+1) -- Data is at end already.
        if Entrystate=="ON" then 
            Entrycolor="green"
        else  Entrystate = "OFF"
             Entrycolor="red"
        end
    end -- Is there data in payload? - Take action if so.
    fnd = {string.find(payload,"Exit=")}
    if #fnd ~= 0 then 
        Exitstate = string.sub(payload,fnd[2]+1) -- Data is at end already.
        if Exitstate=="ON" then 
            Exitcolor="green"
        else  Exitstate = "OFF"
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
    conn:send('input[type="submit"] {\n')
    conn:send('color:#050; width:70px; padding:10px;\n')
    conn:send('font: bold 84% "trebuchet ms",helvetica,sans-serif;\n')
    conn:send('background-color:lightgreen;\n')
    conn:send('border:1px solid; border-radius: 12px;\n')
    conn:send('transition-duration: 0.4s;\n')
    conn:send('}\n')
    conn:send('input[type="submit"]:hover {\n')
    conn:send('background-color:lightblue;\n')
    conn:send('color: white;\n')
    conn:send('}')
    conn:send('</style></head>\n')
    -- HTML body Page content.
    conn:send('<body>')
    conn:send('<h1>Control of door latch.</h1>\n')
   -- HTML Form (POST type) and buttons.
    conn:send('<form action="" method="POST">\n')
    conn:send('<input type="submit" name="Entry" ' )
    if Entrystate=="ON" then
            conn:send('value="ON" style="background-color:green" > Turn Entry Latch ON<br><br>\n')
    else
            conn:send('value="OFF" style="background-color:red" > Turn Entry Latch OFF<br><br>\n')
    end 
    conn:send('<input type="submit" name="Exit" ')        
    if Exitstate=="ON" then
            conn:send('value="ON" style="background-color:green" > Turn Exit Latch ON<br><br>\n')
    else
            conn:send('value="OFF" style="background-color:red" > Turn Exit Latch OFF<br><br>\n')
    end 
    conn:send('</body></html>\n')
    conn:on("sent",function(conn) conn:close() end)
    end)
end)
end
