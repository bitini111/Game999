local skynet = require "skynet"
local CMD={}
skynet.start(function()
    skynet.error("this is Test.lua")
    -- skynet.getenv("logpath")
    -- local r = skynet.call("login", "lua", 1, "nengzhong", true)
    -- skynet.error("skynet.call return value:", r)

    -- skynet.dispatch("lua", function(_, session, cmd, subcmd, ...)
    --     if cmd == "socket" then
    --         -- local f = sock_mgr[subcmd]
    --         -- f(sock_mgr, ...)
    --         -- socket api don't need return
    --     else
    --         local f = CMD[cmd]
    --         assert(f, cmd)
    --         if session == 0 then
    --             f(subcmd, ...)
    --         else
    --             skynet.ret(skynet.pack(f(subcmd, ...)))
    --         end

    --     end
    -- end)
    -- skynet.register("test1")

    -- skynet.dispatch("lua", function(session, address, ...)
    --     --dosomething(session, address, ...)
    -- end)
    -- skynet.register(".test")


end)