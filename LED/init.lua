-- Pin init
pins = {
    ["pin_red"] = 6,
    ["pin_yellow"] = 1,
    ["pin_green"] = 3
}

detect_pin = 7

for pinName, pinAddr in pairs(pins) do
    gpio.mode(pinAddr, gpio.OUTPUT)
    gpio.write(pinAddr, gpio.LOW)
    print (pinName .. ' set ' .. gpio.LOW)
end

gpio.write(detect_pin, gpio.LOW)
gpio.mode(detect_pin, gpio.INPUT)

-- set pin_green to pwd mode and init state
pwm.setup(pins["pin_green"], 1000, 0)
pwm.start(pins["pin_green"])

-- dhcp init
dhcp_config = {}
dhcp_config.start = "192.168.1.100"
wifi.ap.dhcp.config(dhcp_config)

-- wifi init
wifi.setmode(wifi.SOFTAP)
wifi_cfg =
{
    ip="192.168.1.1",
    netmask="255.255.255.0",
    gateway="192.168.1.1"
}
wifi.ap.setip(wifi_cfg)
wifi.ap.config({ssid="nodeMCU", pwd="12345678", auth=wifi.WPA2_PSK})

-- print wifi info
print("ap ip:"..wifi.ap.getip())
print("ap mac:"..wifi.ap.getmac())
print("sta mac:"..wifi.sta.getmac())

-- Serving static files
dofile('httpServer.lua')
httpServer:listen(80)
print("Http Server started ...")

-- regist flash led timer
pin_yellow_timer = tmr.create()
pin_yellow_timer:register(500, tmr.ALARM_AUTO, function() 
    currentState = gpio.read(pins["pin_yellow"]) + 1
    if currentState > 1 then 
        currentState = 0 
    end
    gpio.write(pins["pin_yellow"], currentState)
end)

-- regist pwm led timer
pin_green_flag = 50;
pin_green_timer = tmr.create()
pin_green_timer:register(50, tmr.ALARM_AUTO, function() 
    currentDuty = pwm.getduty(pins["pin_green"])
    if currentDuty > 1023 - pin_green_flag then 
        pin_green_flag = pin_green_flag * -1 
        pwm.setduty(pins["pin_green"], 1023)
    elseif currentDuty < 0 - pin_green_flag then
        pin_green_flag = pin_green_flag * -1
        pwm.setduty(pins["pin_green"], 0)
    else
        currentDuty = currentDuty + pin_green_flag
        pwm.setduty(pins["pin_green"], currentDuty)
    end
end)

detect_move = 0
detect_pin_timer = tmr.create()
detect_pin_timer:register(100, tmr.ALARM_AUTO, function() 
    detect_move = gpio.read(detect_pin)
end)
detect_pin_timer:start()

-- Led API
httpServer:use('/led', function(req, res)
    print('Operation ' .. req.query.pinName .. ' to ' .. req.query.state )
    if req.query.pinName == "pin_red" and req.query.state ~= nil then
        gpio.write(pins[req.query.pinName], req.query.state)
    elseif req.query.pinName == "pin_yellow" and req.query.state == "1" then
        pin_yellow_timer:start()
    elseif req.query.pinName == "pin_yellow" and req.query.state == "0" then
        pin_yellow_timer:stop()
        gpio.write(pins["pin_yellow"], 0)
    elseif req.query.pinName == "pin_green" and req.query.state == "1" then
        pwm.setduty(pins["pin_green"], pin_green_flag)
        pin_green_timer:start()
    elseif req.query.pinName == "pin_green" and req.query.state == "0" then
        pin_green_timer:stop()
        pwm.setduty(pins["pin_green"], 0)
    end 
    res:send('Operation ' .. req.query.pinName .. ' to ' .. req.query.state )
end)

-- Detect API
httpServer:use('/detect', function(req, res)
    res:send(detect_move)
end)



