local skynet = require "skynet"
skynet.start(function()
    skynet.error("this is Test1.lua")
    -- skynet.getenv("logpath")
end)