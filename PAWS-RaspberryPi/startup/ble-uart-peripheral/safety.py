import busio
import time
import digitalio
import board
import adafruit_mcp3xxx.mcp3008 as MCP
import matplotlib.pyplot as plt
import numpy as np
from rgbmatrix import graphics
from adafruit_mcp3xxx.analog_in import AnalogIn
from samplebase import SampleBase
import uart_peripheral
import settings
from gi.repository import GLib
mainloop = None

class GraphicsTest(SampleBase):
            def __init__(self, *args, **kwargs):
                super(GraphicsTest, self).__init__(*args, **kwargs)
            def run(self):
                canvas = self.matrix
                font = graphics.Font()
                font.LoadFont("7x13.bdf")
                customcolor = graphics.Color(int(settings.modeDataArray[0]), int(settings.modeDataArray[1]), int(settings.modeDataArray[2]))
                for i in range(64):
                    if(settings.fakemax<800):
                        graphics.DrawLine(canvas, i, 31, i, 31, customcolor)
                    else:
                        graphics.DrawLine(canvas, i, 31, i, 31-settings.printfourier[i], customcolor)
                #time.sleep(0.1)

def main():
    global mainloop
    mainloop = GLib.MainLoop()
    spi = busio.SPI(clock=board.SCK, MISO=board.MISO, MOSI=board.MOSI)
    cs = digitalio.DigitalInOut(board.D7)
    mcp = MCP.MCP3008(spi, cs)
    # settings.init()
    # print(settings.modeData)
    # splitted=settings.modeData.split("_")
    # print(splitted[4])
    # print(settings.modeData)
    # print(settings.modeDataArray)
    uart_peripheral.runBLE()

    for m in range(1):           
        vals=np.zeros(70)
        channel = AnalogIn(mcp, MCP.P6)
        for i in range(70):
            vals[i]=channel.value  
        fourier = np.fft.fft(vals)
        sfourier=np.zeros(70)
        settings.printfourier=np.zeros(64)
        finalfourier=abs(fourier[1:33])
        maxf=25000
        settings.fakemax=max(finalfourier)
        minf=min(finalfourier)
        for i in range(32):
            top=(finalfourier[i]-minf)
            bottom=maxf-minf
            settings.printfourier[2*i]=round((top/bottom)*31)
            settings.printfourier[(2*i)+1]=round((top/bottom)*31)
        graphics_test = GraphicsTest()
        if (not graphics_test.process()):
            graphics_test.print_help()
    try:
        mainloop.run()
    except KeyboardInterrupt:
        mainloop.quit()      
        
if __name__ == "__main__":
    main()
    print(settings.modeDataArray)

    # graphics_test = GraphicsTest(fakemax,printfourier)
    # if (not graphics_test.process()):
    #     graphics_test.print_help()

# import smbus
# DEVICE_BUS = 1
# DEVICE_ADDR1 = 0x36
# DEVICE_ADDR2 = 0x4B
# reg_write_dac = 0x40
# bus = smbus.SMBus(DEVICE_BUS)
# bus.write_i2c_block_data(DEVICE_ADDR2, reg_write_dac,msg)