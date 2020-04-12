local skynet = require "skynet"
require "skynet.manager"
local max_client = 64
skynet.start(function()
    -- skynet.error("Fisrt skynet service SERVICE_NAME",SERVICE_NAME)
    -- skynet.getenv("logpath")
    local handle =skynet.newservice("test")
    skynet.exit()
    -- skynet.error("address",skynet.address(handle))
    -- skynet.exit()

    -- local watchdog = skynet.newservice("watchdog")
	-- skynet.call(watchdog, "lua", "start", {
	-- 	port = 8888,
	-- 	maxclient = max_client,
	-- 	nodelay = true,
	-- })
	-- skynet.error("Watchdog listen on", 8888)
	-- skynet.exit()

end)