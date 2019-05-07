-- Pin init
detect_pin = 7

gpio.write(detect_pin, gpio.LOW)
gpio.mode(detect_pin, gpio.INPUT)

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

detect_move = 0
detect_pin_timer = tmr.create()
detect_pin_timer:register(100, tmr.ALARM_AUTO, function() 
    detect_move = gpio.read(detect_pin)
end)
detect_pin_timer:start()

-- Detect API
httpServer:use('/detect', function(req, res)
    res:send(detect_move)
end)



