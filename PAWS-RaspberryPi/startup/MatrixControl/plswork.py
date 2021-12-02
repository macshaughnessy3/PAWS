import busio
import time
import digitalio
import board
import adafruit_mcp3xxx.mcp3008 as MCP
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

#for m in range(1):
while(1):
    with open("/home/pi/Code/PAWS/PAWS-RaspberryPi/data/messages.txt", "rb") as file:
        file.seek(-2, 2)
        while file.read(1) != b'\n':
            file.seek(-2, 1)
        last_line = file.readline().decode()
    last_line=last_line.split("_")
 ##################################################################
    if int(last_line[3])==0:

        for i in range(70):
            vals[i]=channel.value

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

  ##########################################################
    if int(last_line[3])==1:

        avg=np.zeros(64)
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

 #################################################################
    if int(last_line[3])==2:

        for i in range(70):
            vals[i]=channel.value

        finalfourier=abs(vals[1:33])
        maxf=4000
        fakemax=max(finalfourier)
        minf=min(finalfourier)

        for i in range(32):
            top=(finalfourier[i]-minf)
            bottom=maxf-minf
            printfourier[2*i]=round((top/bottom)*31)
            printfourier[(2*i)+1]=round((top/bottom)*31)

 ##################################################################
    if int(last_line[3])==3:

        class RunText(SampleBase):
            def __init__(self, *args, **kwargs):
                super(RunText, self).__init__(*args, **kwargs)
                #self.parser.add_argument("-t", "--text", help="The text to scroll on the RGB LED panel", default="Hello world!")

            def run(self):
                canvas = self.matrix
                canvas.Clear()
                textColor = graphics.Color(float(last_line[0]),float(last_line[1]), float(last_line[2]))

                offscreen_canvas = self.matrix.CreateFrameCanvas()
                font = graphics.Font()
                font.LoadFont("/home/pi/Code/PAWS/PAWS-RaspberryPi/startup/ble-uart-peripheral/7x13.bdf")
                pos = offscreen_canvas.width
                my_text = last_line[4]
                t_end = time.time() + 10

                while True:

                    offscreen_canvas.Clear()
                    len = graphics.DrawText(offscreen_canvas, font, pos, 10, textColor, my_text)
                    pos -= 1
                    if (pos + len < 0):
                        pos = offscreen_canvas.width
                        #print("its ova")
                        break

                    time.sleep(0.05)
                    offscreen_canvas = self.matrix.SwapOnVSync(offscreen_canvas)

        # Main function
        if __name__ == "__main__":
            run_text = RunText()
            if (not run_text.process()):
                run_text.print_help()
            #time.sleep(10)

    elif int(last_line[3])<3 and int(last_line[3])>-1:
        class FFT(SampleBase):

            def __init__(self, *args, **kwargs):
                super(FFT, self).__init__(*args, **kwargs)

            def run(self):
                canvas = self.matrix
                font = graphics.Font()
                font.LoadFont("/home/pi/Code/PAWS/PAWS-RaspberryPi/startup/ble-uart-peripheral/7x13.bdf")
                #print("hello there\n\n")


                color = graphics.Color(float(last_line[0]),float(last_line[1]), float(last_line[2]))
                for i in range(64):
                   # if(fakemax<1000):
                    #    graphics.DrawLine(canvas, i, 31, i, 31, color)
                   # else:
                    graphics.DrawLine(canvas, i, 31, i, 31-printfourier[i], color)

        if __name__ == "__main__":
            graphics_test = FFT()
            if (not graphics_test.process()):
                graphics_test.print_help()

##########################################################
    if int(last_line[3])==-1:
        #print("hello")
        while(1):
            break
