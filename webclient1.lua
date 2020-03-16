--- Get data (via console) and send to host web server
-- usage: call functions setServer() and pass REQ 
--  with appropriate key/value pairs,call sendReq() to send it
function setServer(param,val)
serverParm[param]=val
end
function sendReq()
buffer=""
REQBODY1= " HTTP/1.1\r\n";
REQBODY2="Host: Wirepusher.com\r\n"
    .. "Connection: close\r\n"
    .. "Accept: */*\r\n"
    .. "User-Agent: Mozilla/4.0 (compatible; esp8266 Lua; Windows NT 5.1)\r\n\r\n"
REQUEST="GET /"..serverParm["SUBDIR"]..REQ..REQBODY1..REQBODY2;
print("Sending data to "..serverParm["IP"])
sk=net.createConnection(net.TCP, 0)
sk:on("receive", function(sck, payload)
    print("received:"..payload)
    buffer=buffer..payload
    end)
sk:on("connection", function(sck)
    conn=sck
    print ("Sending: "..REQUEST.."...\r\n");
    conn:send(REQUEST)
    end)
sk:on("sent",function(sck)
      endTimer:alarm(endTimeout,tmr.ALARM_SINGLE,function()  
      print("Closing http connection")
      sck:close()
      end)    
    end)
sk:connect(80,serverParm["IP"])
end
--  START HERE - just init (all funtions called via console)
serverParm={} -- connection params  for REMOTE server
endTimeout=6000       --  timer in ms
endTimer=tmr.create()  -- init end timer
