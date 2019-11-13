-- configure for 115200, 8N1, with echo
uart.setup(0, 115200, 8, uart.PARITY_NONE, uart.STOPBITS_1, 1)
uart.on("data", "\r",
  function(data)
    if(#Log>Loglim) then
      table.remove(Log,1)
    end
    table.insert(Log,data)  
    -- Log[#Log+1]=data
    -- fnd = {string.find(data,"#M")}
    -- if #fnd ~= 0 then 
    --      arg = string.sub(data,fnd[2]+1)
    --      print("arg="..arg) 
    -- end
    end, 0)
