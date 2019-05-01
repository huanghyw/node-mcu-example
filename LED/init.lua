pins = {
    ["pin_red"] = 6,
    ["pin_yellow"] = 1,
    ["pin_green"] = 3
}

for pinName, pinAddr in pairs(pins) do
    gpio.mode(pinAddr, gpio.OUTPUT)
    gpio.write(pinAddr, gpio.LOW)
    print (pinName .. ' set ' .. gpio.LOW)
end



wifi.setmode(wifi.SOFTAP)

cfg =
{
    ip="192.168.1.1",
    netmask="255.255.255.0",
    gateway="192.168.1.1"
}

wifi.ap.setip(cfg)

dhcp_config ={}
dhcp_config.start = "192.168.1.100"
wifi.ap.dhcp.config(dhcp_config)

wifi.ap.config({ssid="nodeMCU", pwd="12345678", auth=wifi.WPA2_PSK})

print("ap ip:"..wifi.ap.getip())
print("ap mac:"..wifi.ap.getmac())
print("sta mac:"..wifi.sta.getmac())


-- Serving static files
dofile('httpServer.lua')
httpServer:listen(80)

-- Custom API
-- Get text/html
httpServer:use('/led', function(req, res)
    print('Operation ' .. req.query.pinName .. ' to ' .. req.query.state )
    if req.query.pinName  ~= nil and req.query.state ~= nil then
        gpio.write(pins[req.query.pinName], req.query.state)
    end 
    res:send('Operation ' .. req.query.pinName .. ' to ' .. req.query.state )
end)



