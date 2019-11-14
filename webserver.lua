-- ESP8266 webserver
-- This allows control of the door Entry/Exit latch
--  assumes valid internet connection active (wifi, ip address)
ENTRY = "ON"
EXIT = "ON"
SERIAL = "OFF"
DEBUG = "OFF"
function server()
	dofile("htmlheader.lua")	-- get html routines	
    srv=net.createServer(net.TCP)
    srv:listen(80,function(conn)
    conn:on("receive",function(conn,payload)
    -- print(payload)  -- View the received data,
    html=header()				-- output html header/stylesheet
    conn:send(html)
	html=form()					-- html body + form header.
	html=html..button(ENTRY,"ENTRY",payload)
	html=html..button(EXIT,"EXIT",payload)
	html=html..button(SERIAL,"SERIAL",payload)
	html=html..button(DEBUG,"DEBUG",payload)
	conn:send(html)
	html=debugout()
	html=html+'</body></html>\n'
    conn:send(html)
    conn:on("sent",function(conn) conn:close() end)
    end)
end)

end
