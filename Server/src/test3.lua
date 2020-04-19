local skynet = require "skynet"
local socket = require "skynet.socket"
local CMD={}

local function echo(ID)
    socket.start(ID)
    skynet.error("ID:",ID,"addr:",addr)
    while(true ) do
        local str,endsrt = socket.read(ID)
        if(str) then
            skynet.error("recv from ID",ID,str)
            socket.write(ID,str)
        else
            skynet.error("socket error",endsrt)
            socket.close(ID)
            break
        end
    end
end

local function accept(ID,addr)
    skynet.error("ID")
    skynet.fork(echo,ID)


end

skynet.start(function()
    skynet.error("this is Test3.lua")
    local ipaddress = "0.0.0.0:8082"
    local lID= socket.listen(ipaddress)
    assert(lID)
    socket.start(lID,accept)


end)