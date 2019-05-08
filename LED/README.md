# LED 的远程控制

**使用AP模式启动WI-FI，并提供DHCP服务**  

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

## 案例1，控制LED开关

**针脚设置为输出模式**  
```
gpio.mode(pinAddr, gpio.OUTPUT)
```
**开启LED，将针脚设置为高电平**  
```
gpio.write(pinAddr, gpio.HIGHT)
```
**关闭LED，将针脚设置为低电平**  
```
gpio.write(pinAddr, gpio.LOW)
```

## 案例2，控制LED闪烁  

**获取一个定时器，并注册要执行的频率、模式、触发函数**  
```
pin_yellow_timer = tmr.create()
pin_yellow_timer:register(500, tmr.ALARM_AUTO, function() 
    currentState = gpio.read(pins["pin_yellow"]) + 1
    if currentState > 1 then 
        currentState = 0 
    end
    gpio.write(pins["pin_yellow"], currentState)
end)
```

**启动定时器** `pin_yellow_timer:start()`

**关闭定时器** `pin_yellow_timer:start()`

## 案例3，LED呼吸灯
**PWM，脉冲宽度调制**

***应用领域***
能量传输控制
```
                _      __     ___    _____   _      _____   __     _   
               | |    |  |   |   |  |     | | |    |     | |  |   | | 
PWM Power      | |    |  |   |   |  |     | | |    |     | |  |   | |  
             __| |____|  |___|   |__|     |_| |____|     |_|  |___| |_____
```
数据传输控制
```
          _      _      _      _      _      _      _      _     
         | |    | |    | |    | |    | |    | |    | |    | |    
Clock    | |    | |    | |    | |    | |    | |    | |    | |    
       __| |____| |____| |____| |____| |____| |____| |____| |____

                 _      __     ____          ____   _
PWM signal      | |    |  |   |    |        |    | | |
                | |    |  |   |    |        |    | | |
       _________| |____|  |___|    |________|    |_| |___________

Data       0     1       2      4      0      4     1      0
```


**启动HTTP Server**  
**启动HTTP Server**  
