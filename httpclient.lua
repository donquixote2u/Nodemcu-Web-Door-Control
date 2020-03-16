--- Get data (via console) and send to host web server
-- usage: call functions setServer() and pass REQ 
--  with appropriate key/value pairs,call sendReq() to send it
function setServer(param,val)
serverParm[param]=val
end
function sendReq()
print("Sending data to "..REQ)
http.get(REQ, nil, function(code, data)
    if (code < 0) then
      print("HTTP request failed")
    else
      print(code, data)
    end
  end)
end
--  START HERE - just init (all funtions called via console)
serverParm={} -- connection params  for REMOTE server
endTimeout=6000       --  timer in ms
endTimer=tmr.create()  -- init end timer
