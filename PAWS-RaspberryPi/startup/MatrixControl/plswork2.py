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

vals=np.zeros(70)
channel = AnalogIn(mcp, MCP.P6)
printfourier=np.zeros(64)
avg=np.zeros(64)

#for m in range(1):

class FastRefreshFFT(SampleBase):

    for i in range(70):
        vals[i]=channel.value
        #print(vals[i])

    fourier = np.fft.fft(vals)
    finalfourier=abs(fourier[1:33])
    maxf=30000
    fakemax=max(finalfourier)
    minf=min(finalfourier)

    for i in range(32):
        top=(finalfourier[i]-minf)
        bottom=maxf-minf
        printfourier[2*i]=round((top/bottom)*31)
        printfourier[(2*i)+1]=round((top/bottom)*31)

    def __init__(self, *args, **kwargs):
        super(FastRefreshFFT, self).__init__(*args, **kwargs)

    def run(self):
        canvas = self.matrix
        font = graphics.Font()
        font.LoadFont("7x13.bdf")

        color = graphics.Color(int(last_line[0]), int(last_line[1]), int(last_line[2]))
        for i in range(64):
           # if(fakemax<1000):
            #    graphics.DrawLine(canvas, i, 31, i, 31, color)
           # else:
            graphics.DrawLine(canvas, i, 31, i, 31-printfourier[i], color)


class SlowFFT(SampleBase):

    for n in range(7):

        for i in range(70):
            vals[i]=channel.value
            #print(vals[i])

        fourier = np.fft.fft(vals)
        finalfourier=abs(fourier[1:33])
        maxf=30000
        fakemax=max(finalfourier)
        minf=min(finalfourier)

        for i in range(32):
            top=(finalfourier[i]-minf)
            bottom=maxf-minf
            printfourier[2*i]=round((top/bottom)*31)
            printfourier[(2*i)+1]=round((top/bottom)*31)

        avg=avg+printfourier

    avg=avg/7

    def __init__(self, *args, **kwargs):
        super(SlowFFT, self).__init__(*args, **kwargs)

    def run(self):
        canvas = self.matrix
        font = graphics.Font()
        font.LoadFont("7x13.bdf")

        color = graphics.Color(int(last_line[0]), int(last_line[1]), int(last_line[2]))
        for i in range(64):
           # if(fakemax<1000):
            #    graphics.DrawLine(canvas, i, 31, i, 31, color)
           # else:
            graphics.DrawLine(canvas, i, 31, i, 31-printfourier[i], color)

def main():
    with open("/home/pi/Code/PAWS/PAWS-RaspberryPi/data/messages.txt", "rb") as file:
        file.seek(-2, 2)
        while file.read(1) != b'\n':
            file.seek(-2, 1)
        last_line = file.readline().decode()
    last_line=last_line.split("_")

    if int(last_line[3]) == 1:
        print("it's 1")
        run = FastRefreshFFT()
        run.process()
    elif int(last_line[3]) == 2:
        print("it's 2")
        bruh = SlowFFT()
        bruh.process()

    # Main function
    if __name__ == "__main__":
        while(1):
            main()



