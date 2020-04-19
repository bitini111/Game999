local skynet = require "skynet"
skynet.start(function()
    skynet.error("this is Test.lua")
    -- skynet.getenv("logpath")
    skynet.newservice("systemlog")
end)