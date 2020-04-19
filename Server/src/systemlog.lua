local skynet = require "skynet"
require "skynet.manager"
local CMD = {}


local function Ttostring(table)
	local cache = {  [table] = "." }
	local function _dump(t,space,name)
		local temp = {}
		for k,v in pairs(t) do
			local key = tostring(k)
			if cache[v] then
				table.insert(temp,"+" .. key .. " {" .. cache[v].."}")
			elseif type(v) == "table" then
				local new_key = name .. "." .. key
				cache[v] = new_key
				table.insert(temp,"+" .. key .. _dump(v,space .. (next(t,k) and "|" or " " ).. srep(" ",#key),new_key))
			else
				table.insert(temp,"+" .. key .. " [" .. tostring(v).."]")
			end
		end
		return table.concat(temp,"\n"..space)
	end
	return _dump(table, "","")
end

local function exists(path)
    local file = io.open(path, "r")
    if file then
        io.close(file)
        return true
    end
    return false
end

local function get_file_name(dirname, filename)
     ----- 日志分日期存储------
    local path = skynet.getenv("logpath")
    if path == nil then
    	path = "."
    end
    if dirname == nil then
 		dirname = "."
 	end
    skynet.error(skynet.time())
    local current_time = os.date("%Y_%m_%d", math.floor(skynet.time()))
    local log_path = path.."/"..current_time.."/"..dirname
    local current_file_name = log_path.."/"..filename
    if exists(log_path) == true then
        os.execute("mkdir -p "..log_path)
    end
    return current_file_name
end

local function clear_log(file)
	local f = io.open(file, "w")
	if f ~= nil then
		f:write("")
		f:close()
	end
end

local function write_log(file, ...)
    skynet.error(skynet.time())
    local f = io.open(file, "a+")
    if f ~= nil then
        f:write("-------------["..os.date("%Y-%m-%d %X", math.floor(skynet.time())).."]--------------\n")
        local arg = table.pack(...)
        if arg ~= nil then
            for key, value in pairs(arg) do
                if key ~= "n" then
                    if type(value) ~= "table" then
                        f:write(tostring(value).."\n")                
                    else
                        local str = Ttostring(value)
                        f:write(str.."\n")                
                    end
                end 
            end
        end
        f:close()
    end	
end

local function write_protomsg_log(file, msgname, ...)
    local f = io.open(file, "a+")
    if f ~= nil then
        f:write("["..os.date("%Y-%m-%d %X", math.floor(skynet.time())).."] msgname: "..msgname.."\n")
        local arg = table.pack(...)
        if arg ~= nil then
            for key, value in pairs(arg) do
                if key ~= "n" then
                    if type(value) ~= "table" then
                        f:write(tostring(value).."\n")                
                    else
                        local str = Ttostring(value)
                        f:write(str.."\n")                
                    end
                end 
            end
        end
        f:close()
    end     
end

local function load_config()
    skynet.error("load_config")
end

function CMD.error(...)
   local file = get_file_name(".", "error.log")
   write_log(file, ...)
end

function CMD.info(...)
    local file = get_file_name(".", "info.log")
    write_log(file, ...)
end

function CMD.warning(...)
    local file = get_file_name(".", "warning.log")
    write_log(file, ...)
end

function CMD.protomsg(msgname, ...)
    local file = get_file_name(".", "protomsg.log")
    write_protomsg_log(file, msgname, ...)
end

function CMD.obj(objname, objid, ...)
	if objname == nil then
		objname = "."
	end
	if objid == nil then
		objid = "unknow"
	end
    local file = get_file_name(objname, objid..".log")
    write_log(file, ...)
end

function CMD.reload(...)
    load_config()
end

function CMD.exit(...)
    skynet.exit()
end

function CMD.start( ... )
    load_config()
end

skynet.dispatch("lua", function(_, address,  cmd, ...)
	    local f = CMD[cmd]
		if f ~= nil then
            f(...)
        end
end)
skynet.start(function()
    CMD.start()
    skynet.register ".systemlog"
end)
