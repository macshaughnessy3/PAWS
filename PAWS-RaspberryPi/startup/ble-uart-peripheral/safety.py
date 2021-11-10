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

spi = busio.SPI(clock=board.SCK, MISO=board.MISO, MOSI=board.MOSI)
cs = digitalio.DigitalInOut(board.D7)
mcp = MCP.MCP3008(spi, cs)
for m in range(1000):


                
    vals=np.zeros(70)
    #vals=[0]*1000
    #t_end=time.time()+1
    channel = AnalogIn(mcp, MCP.P6)
    #i=0
    #while time.time()<t_end:
    #t1_start = time.perf_counter()
        #vals[i]=channel.value
        #i+=1

    for i in range(70):
        #x=channel.value
        #print('Raw ADC Value: ', x)

        #channel2 = AnalogIn(mcp, MCP.P1)
        #vals.append(channel.value)
        vals[i]=channel.value
        #time.sleep(0.005)
        #print('Raw ADC Value: ', vals[i])
        #print('ADC Voltage: ' + str(channel.voltage) + 'V')
        
    #t1_stop = time.perf_counter()

    #print("Elapsed time during the whole program in seconds:",t1_stop-t1_start)
    #print(vals)
    fourier = np.fft.fft(vals)
    sfourier=np.zeros(70)
    #maximum=max(fourier)
    #print(maximum)
    #for i in range(4096):
    #fourier[i]=(fourier[i]-15000)
    #for i in range(4,66):
    #    add=0
    #    for j in range(-2,3):
    #	    add=add+fourier[i+j]
    #   avg=add/5
    #   sfourier[i]=avg
    plt.plot(abs(sfourier[1:33]))
    plt.xlabel("Hz")
    #plt.show()
    printfourier=np.zeros(64)
    finalfourier=abs(fourier[1:33])
    #maxf=35000
    maxf=20000

    fakemax=max(finalfourier)

    minf=min(finalfourier)
    #print(maxf,minf)

    for i in range(32):
        top=(finalfourier[i]-minf)
        bottom=maxf-minf
        printfourier[2*i]=round((top/bottom)*31)
        printfourier[(2*i)+1]=round((top/bottom)*31)

        #print(finalfourier[i],finalfourier[i+1])
        


    class GraphicsTest(SampleBase):
        def __init__(self, *args, **kwargs):
            super(GraphicsTest, self).__init__(*args, **kwargs)

        def run(self):
            canvas = self.matrix
            font = graphics.Font()
            font.LoadFont("7x13.bdf")

            red = graphics.Color(255, 0, 0)
            for i in range(64):
                if(fakemax<3000):
                    graphics.DrawLine(canvas, i, 31, i, 31, red)
                else:
                    graphics.DrawLine(canvas, i, 31, i, 31-printfourier[i], red)


            #green = graphics.Color(0, 255, 0)
        #graphics.DrawCircle(canvas, 15, 15, 10, green)

        #blue = graphics.Color(0, 0, 255)
            #graphics.DrawText(canvas, font, 2, 10, blue, "im gay")

            time.sleep(0.1)   # show display for 10 seconds before exit


    # Main function
    if __name__ == "__main__":
        graphics_test = GraphicsTest()
        if (not graphics_test.process()):
            graphics_test.print_help()

