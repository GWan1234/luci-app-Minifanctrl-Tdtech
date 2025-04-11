module("luci.controller.fancontrol", package.seeall)

function index()
	entry({"admin", "status", "fancontrol"}, template("zmode/fancontrol"), _("风扇控制"), 94)
	entry({"admin", "modem", "fanstop"}, call("action_fanstop"))
	entry({"admin", "modem", "fanst1"}, call("action_fanst1"))
	entry({"admin", "modem", "fanst2"}, call("action_fanst2"))
	entry({"admin", "modem", "fanst3"}, call("action_fanst3"))
	entry({"admin", "modem", "fanst4"}, call("action_fanst4"))
	entry({"admin", "modem", "fansttp"}, call("action_fansttp"))
	entry({"admin", "modem", "fanst"}, call("action_fanst"))
	entry({"admin", "modem", "mwrtdf"}, call("action_mwrtdf"))
	entry({"admin", "modem", "mwrtco"}, call("action_mwrtco"))
	entry({"admin", "modem", "mwrtpk"}, call("action_mwrtpk"))
end

function action_fanst()
    local rv = {}
    local file_path = "/sys/devices/platform/pwm-fan/hwmon/hwmon0/pwm1"
    local file = io.open(file_path, "r")
    if file then
        local content = file:read("*a")
        file:close()
        rv["fanspd"] = content
    else
        rv["fanspd"] = "未获取到转速"
    end
    
    local process_check = io.popen("pgrep -f fancts.sh")
    local process_result = process_check:read("*a")
    process_check:close()
    
    if process_result ~= "" then
        rv["fancts"] = "智能"
    else
        rv["fancts"] = "手动"
    end

    local p = luci.http.formvalue("p")
    local set = luci.http.formvalue("set")
    local fixed = set
    local port = string.gsub(p, "\"", "~")
    rv["at"] = fixed 
    rv["port"] = port
    
    luci.http.prepare_content("application/json")
    luci.http.write_json(rv)
end


function action_fansttp()
	local rv = {}
	local file
	local p = luci.http.formvalue("p")
	local set = luci.http.formvalue("set")
	local fixed = set
	local port = string.gsub(p, "\"", "~")
	
	local temp_file = "/sys/class/thermal/thermal_zone0/temp"
	local temperature = 0

	file = io.open(temp_file, "r")
	if file then
		temperature = file:read("*n")
		file:close()
		temperature = temperature / 1000
	else
		temperature = "null"
	end
	
	rv["at"] = fixed 
	rv["port"] = port
	rv["fansttp"] = temperature

	luci.http.prepare_content("application/json")
	luci.http.write_json(rv)
end


function action_fanst2()
	local rv ={}
	local file
	local p = luci.http.formvalue("p")
	local set = luci.http.formvalue("set")
	fixed = set
	port= string.gsub(p, "\"", "~")
	rv["at"] = fixed 
	rv["port"] = port
	local handle = io.popen("pgrep -f fancts.sh")
    local pid = handle:read("*a")
    handle:close()

    if pid then
        pid = pid:match("%d+") 
        if pid then
            os.execute("kill " .. pid)
        end
    end
	os.execute("echo 1 > /etc/fanvall")
	os.execute("echo 2 > /sys/class/thermal/cooling_device0/cur_state")
	rv["result"] = "fanst2"
	luci.http.prepare_content("application/json")
	luci.http.write_json(rv)
end

function action_fanst1()
	local rv ={}
	local file
	local p = luci.http.formvalue("p")
	local set = luci.http.formvalue("set")
	fixed = set
	port= string.gsub(p, "\"", "~")
	rv["at"] = fixed 
	rv["port"] = port
	local handle = io.popen("pgrep -f fancts.sh")
    local pid = handle:read("*a")
    handle:close()

    if pid then
        pid = pid:match("%d+") 
        if pid then
            os.execute("kill " .. pid)
        end
    end
	os.execute("echo 1 > /etc/fanvall")
	os.execute("echo 1 > /sys/class/thermal/cooling_device0/cur_state")
	rv["result"] = "fanst2"
	luci.http.prepare_content("application/json")
	luci.http.write_json(rv)
end

function action_fanst3()
	local rv ={}
	local file
	local p = luci.http.formvalue("p")
	local set = luci.http.formvalue("set")
	fixed = set
	port= string.gsub(p, "\"", "~")
	rv["at"] = fixed 
	rv["port"] = port
	local handle = io.popen("pgrep -f fancts.sh")
    local pid = handle:read("*a")
    handle:close()

    if pid then
        pid = pid:match("%d+") 
        if pid then
            os.execute("kill " .. pid)
        end
    end
	os.execute("echo 3 > /etc/fanvall")
	os.execute("echo 3 > /sys/class/thermal/cooling_device0/cur_state")
	rv["result"] = "fanst3"
	luci.http.prepare_content("application/json")
	luci.http.write_json(rv)
end

function action_fanst4()
    local rv = {}
    local p = luci.http.formvalue("p")
    local set = luci.http.formvalue("set")
    local fixed = set
    local port = string.gsub(p, "\"", "~")

    rv["at"] = fixed 
    rv["port"] = port
    local handle = io.popen("pgrep -f fancts.sh")
    local pid = handle:read("*a")
    handle:close()

    if pid then
        pid = pid:match("%d+") 
        if pid then
            os.execute("kill " .. pid)
        end
    end
	os.execute("echo 9 > /etc/fanvall")
    os.execute("/usr/bin/fancts.sh &")
    rv["result"] = "fanst4"
    
    luci.http.prepare_content("application/json")
    luci.http.write_json(rv)
end


function action_fanstop()
	local rv ={}
	local file
	local p = luci.http.formvalue("p")
	local set = luci.http.formvalue("set")
	fixed = set
	port= string.gsub(p, "\"", "~")
	rv["at"] = fixed 
	rv["port"] = port
	local handle = io.popen("pgrep -f fancts.sh")
    local pid = handle:read("*a")
    handle:close()

    if pid then
        pid = pid:match("%d+") 
        if pid then
            os.execute("kill " .. pid)
        end
    end
	os.execute("echo 0 > /etc/fanvall")
	os.execute("echo 0 > /sys/class/thermal/cooling_device0/cur_state")
	rv["result"] = "fanstop"
	luci.http.prepare_content("application/json")
	luci.http.write_json(rv)
end

