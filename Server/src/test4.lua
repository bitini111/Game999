local skynet = require "skynet"
local protobuf = require "protobuf"

local CMD={}

function CMD.error(...)
    local file = get_file_name(".", "error.log")
    write_log(file, ...)
 end

function Val2Str(value)
    local value_cach = {}   -- 防止闭环
    local tinsert = table.insert
    local tconcat = table.concat
    local sformat = string.format
    local sgsub = string.gsub
    function _Val2Str(value, prefix)
        local str = ""
        local tbList = {}
        local oldprefix = prefix or ""
        prefix = oldprefix.."   "
        local value_type = type(value)
        if value_type == "table" then
            local value_name = tostring(value)
            if value_cach[value] then
                -- 循环打印，直接用table的地址，并给个提示
                return sformat("\"%s\" , -- loop table", value_name)
            end

            value_cach[value] = 1
            tinsert(tbList, sformat("%s--%s", '{', value_name))
            for k, v in pairs(value) do 
                local temp = _Val2Str(v, prefix)
                local key
                if type(k) == "number" then
                    key = sformat("[%s]", k)
                else
                    key = sformat("[\"%s\"]", tostring(k))
                end
                local line = sformat("%s%s = %s,", prefix, key, temp)
                tinsert(tbList, line)
            end
            tinsert(tbList, oldprefix..'}')
        elseif value_type == "number" then
            tinsert(tbList, tostring(value))
        elseif value_type == "string" then
            local temp = tostring(value)
            temp = sgsub(temp, "\\", "\\\\")
            temp = sgsub(temp, "\n", "\n"..prefix.."    ")
            local temp = sformat("[==[%s]==]", temp)
            tinsert(tbList, temp)
        else
            -- 非数字和字符串的，直接调用tosgring获取显示值
            local temp = sformat("\"%s\"", tostring(value))
            tinsert(tbList, temp)
        end

        str = tconcat(tbList, "\n")
        return str
    end
    local str = _Val2Str(value)
    print(str)
    return str
end




local function dumpsheet(v)
	if type(v) == "string" then
		return v
	else
		return dump.dump(v)
	end
end



local function LOG_INFO(fmt, ...)
    local msg = string.format(fmt, ...)
    local info = debug.getinfo(2)
    if info then
        msg = string.format("[%s:%d] %s", info.short_src, info.currentline, msg)
    end
    skynet.send(".systemlog", "lua", "info", SERVICE_NAME, msg)
    return msg
end


local function init()
    protobuf.register_file("./src/netmsg.pb")
end
skynet.start(function()
    init()
    skynet.error("this is Test4.lua")
    skynet.newservice("systemlog")
    local stringbuffer = protobuf.encode("netmsg.NetMsg",
    {
        id = 1,
        payload=3;
        code=100;
    })
 
    skynet.error("TableSize=",#stringbuffer)
    -- Val2Str(stringbuffer)
    --print(dumpsheet(stringbuffer))
    -- skynet.error("stringbuffer=", dumpsheet(stringbuffer))
    local data = protobuf.decode("netmsg.NetMsg",stringbuffer)
    LOG_INFO("data=",data)
    -- skynet.error("数据编码：name="..data.id..",id="..data.payload,data.code)
    -- Val2Str(data)

    -- CMD.error(data)
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