--- Get data (via console) and send to host web server
-- usage: call functions setServer() and pass REQ 
--  with appropriate key/value pairs,call sendReq() to send it
function setServer(param,val)
serverParm[param]=val
end
function sendReq()
buffer=""
REQ="login_id="..MAIL_ID.."&login_pw="..MAIL_PW.."&"..REQ
REQBODY1= " HTTP/1.0\r\n";
REQBODY2="Content-Type: application/x-www-form-urlencoded\r\nContent-Length: "
-- REQUEST="POST /"..serverParm["SUBDIR"]..REQ..REQBODY1..REQBODY2;
REQUEST="POST /"..serverParm["SUBDIR"]..REQBODY1..REQBODY2..#REQ.."\r\n\r\n"..REQ;
-- connection to server
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
      print("Closing smtp connection")
      sck:close()
      end)    
    end)
sk:connect(80,serverParm["IP"])
end
--  START HERE - just init (all funtions called via console)
serverParm={} -- connection params  for REMOTE server
endTimeout=6000       --  timer in ms
endTimer=tmr.create()  -- init end timer
require("mail_credentials")
