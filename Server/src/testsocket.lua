local skynet = require "skynet"
local socket = require "skynet.socket"

--简单echo服务
function echo(cID, addr)
    socket.start(cID)
    while true do
        local str, endstr = socket.read(cID)
        if str then
            skynet.error("recv " ..str)
            socket.write(cID, str)
        else
            socket.close(cID)
            skynet.error(addr .. " disconnect, endstr", endstr)
            return
        end
    end
end

function accept(cID, addr)
    skynet.error(addr .. " accepted")
    skynet.fork(echo, cID, addr) --来一个连接，就开一个新的协程来处理客户端数据
end


skynet.start(function()
    skynet.error("this is testscoket.lua")
    local addr = "0.0.0.0:8010"
    skynet.error("listen " .. addr)
    local lID = socket.listen(addr)
    --或者 local lID = socket.listen("0.0.0.0", 8001, 128)
    assert(lID)
    socket.start(lID, accept) --把套接字与当前服务绑定
    -- skynet.getenv("logpath")
end)