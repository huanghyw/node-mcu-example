**HC-SR501人体感应模块**

![HC-SR501](https://github.com/huanghyw/node-mcu-example/blob/master/resource/HC-SR501_01.jpg)

![HC-SR501](https://github.com/huanghyw/node-mcu-example/blob/master/resource/HC-SR501_02.jpg)

![HC-SR501](https://github.com/huanghyw/node-mcu-example/blob/master/resource/HC-SR501_03.jpg)

![HC-SR501](https://github.com/huanghyw/node-mcu-example/blob/master/resource/HC-SR501_04.jpg)

| | HC-SR501人体感应模块 |
|-|:-|
|工作电压范围 | 直流电压4.5-20V |
|静态电流 | <50uA |
|电平输出 | 高3.3 V /低0V |
|触发方式 | L 不可重复触发/H 重复触发  (默认重复触发) |
|延时时间 | 0.5-200S(可调)可制作范围零点几秒-几十分钟 |
|封锁时间 | 2.5S(默认)可制作范围零点几秒-几十秒 |
|电路板外形尺寸 | 32mm*24mm |
|感应角度 | <100度锥角 |
|工作温度 | -15-+70度 |

**准备工作**  

```
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
```

**启动HTTP Server**  
```
dofile('httpServer.lua')
httpServer:listen(80)
```

**设置针脚模式**
```
detect_pin = 7

gpio.write(detect_pin, gpio.LOW)
gpio.mode(detect_pin, gpio.INPUT)
```

**定时检测**
```
detect_move = 0
detect_pin_timer = tmr.create()
detect_pin_timer:register(100, tmr.ALARM_AUTO, function() 
    detect_move = gpio.read(detect_pin)
end)
detect_pin_timer:start()
```

**提供API接口**  
```
httpServer:use('/detect', function(req, res)
    res:send(detect_move)
end)
```
