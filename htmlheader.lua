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
    local txt='<button type="submit" name="'.button_name.'" ' )
    fnd = {string.find(qrystring,button_name.."=")}
    if #fnd ~= 0 then 
        button_state = string.sub(qrystring,fnd[2]+1)  -- change button state to received value
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
    txt=txt+'value="'..value..' style="background-color:'..colour..'" >'..button_name..' '..state_desc..'</button><br><br>\n'      
    -- print("#O")                     
    txt=txt..'</button><br><br>\n')
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
