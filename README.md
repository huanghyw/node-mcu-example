# node-mcu-example

***基于 [ESP8266](https://www.espressif.com/en/products/hardware/esp8266ex/overview) 芯片，使用 [NodeMCU](https://nodemcu.readthedocs.io/en/master/) 固件，简单的智能硬件原型***  

![NodeMCU DevKit](https://raw.githubusercontent.com/nodemcu/nodemcu-devkit-v1.0/master/Documents/NodeMCU_DEVKIT_1.0.jpg)  

![NodeMCU DevKit](https://raw.githubusercontent.com/nodemcu/nodemcu-devkit-v1.0/master/Documents/NODEMCU_DEVKIT_V1.0_PINMAP.png)  

## [LED](https://github.com/huanghyw/node-mcu-example/tree/master/LED)
可使用http协议控制LED灯开启与关闭，明暗的调节。  
其中使用了基本的IO操作，也涉及了可调占空比相关知识。

## [Detect](https://github.com/huanghyw/node-mcu-example/tree/master/Detect)
使用HC-SR501模块进行移动生物红外检测，当检测到目标时，模块out pin输出高电平，否则为低电平。  
将pin设置为读模式，即可通过读取电平状态判断是否检测到移动生物。
