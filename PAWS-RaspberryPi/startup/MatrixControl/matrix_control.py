import busio                                    # type: ignore
import time
import digitalio                                # type: ignore
import board                                    # type: ignore
import adafruit_mcp3xxx.mcp3008 as MCP          # type: ignore
import numpy as np
from rgbmatrix import graphics
from adafruit_mcp3xxx.analog_in import AnalogIn # type: ignore
from samplebase import SampleBase
from PIL import Image


spi = busio.SPI(clock=board.SCK, MISO=board.MISO, MOSI=board.MOSI)
cs = digitalio.DigitalInOut(board.D7)
mcp = MCP.MCP3008(spi, cs)

vals=np.zeros(70)
channel = AnalogIn(mcp, MCP.P6)
printfourier=np.zeros(64)

#for m in range(1):

with open("/home/pi/Code/PAWS/PAWS-RaspberryPi/data/messages.txt", "rb") as file:
    file.seek(-2, 2)
    while file.read(1) != b'\n':
        file.seek(-2, 1)
    last_line = file.readline().decode()
last_line=last_line.split("_")

while(1):
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

    ##################################################################
    if int(last_line[3])==1:

        avg=np.zeros(64)
        for n in range(7):

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

            avg=avg+printfourier

        avg=avg/7

    ##################################################################
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
                global last_line
                canvas = self.matrix
                prev=last_line[4]
                textColor = graphics.Color(float(last_line[0]),float(last_line[1]), float(last_line[2]))

                offscreen_canvas = self.matrix.CreateFrameCanvas()
                font = graphics.Font()
                font.LoadFont("/home/pi/Code/PAWS/PAWS-RaspberryPi/startup/MatrixControl/7x13.bdf")
                pos = offscreen_canvas.width
                my_text = last_line[4]
                #t_end = time.time() + 10

                while True:
                    with open("/home/pi/Code/PAWS/PAWS-RaspberryPi/data/messages.txt", "rb") as file:
                        file.seek(-2, 2)
                        while file.read(1) != b'\n':
                            file.seek(-2, 1)
                        last_line = file.readline().decode()
                    last_line=last_line.split("_")
                    if int(last_line[3])!=3 or prev != last_line[4]:
                        canvas.Clear()
                        break
                    offscreen_canvas.Clear()
                    len = graphics.DrawText(offscreen_canvas, font, pos, 18, textColor, my_text)
                    pos -= 1
                    if (pos + len < 0):
                        pos = offscreen_canvas.width
                        #break

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
                global last_line
                canvas = self.matrix
                font = graphics.Font()
                font.LoadFont("/home/pi/Code/PAWS/PAWS-RaspberryPi/startup/MatrixControl/7x13.bdf")

                color = graphics.Color(float(last_line[0]),float(last_line[1]), float(last_line[2]))
                for i in range(64):
                   # if(fakemax<1000):
                    #    graphics.DrawLine(canvas, i, 31, i, 31, color)
                   # else:
                    graphics.DrawLine(canvas, i, 31, i, 31-printfourier[i], color)

                with open("/home/pi/Code/PAWS/PAWS-RaspberryPi/data/messages.txt", "rb") as file:
                    file.seek(-2, 2)
                    while file.read(1) != b'\n':
                        file.seek(-2, 1)
                    last_line = file.readline().decode()
                last_line=last_line.split("_")
                if int(last_line[3])!=0 and int(last_line[3])!=1 and int(last_line[3])!=2:
                    canvas.Clear()
       
        if __name__ == "__main__":
            graphics_test = FFT()
            if (not graphics_test.process()):
                graphics_test.print_help()
                
    elif int(last_line[3])==4:
                
        class PulsingColors(SampleBase):
            def __init__(self, *args, **kwargs):
                super(PulsingColors, self).__init__(*args, **kwargs)

            def run(self):
                global last_line
                canvas = self.matrix
                self.offscreen_canvas = self.matrix.CreateFrameCanvas()
                continuum = 0

                while True:
                    with open("/home/pi/Code/PAWS/PAWS-RaspberryPi/data/messages.txt", "rb") as file:
                        file.seek(-2, 2)
                        while file.read(1) != b'\n':
                            file.seek(-2, 1)
                        last_line = file.readline().decode()
                    last_line=last_line.split("_")
                    if int(last_line[3])!=4:
                       canvas.Clear() 
                       break
                    self.usleep(5 * 1000)
                    continuum += 1
                    continuum %= 3 * 255

                    red = 0
                    green = 0
                    blue = 0

                    if continuum <= 255:
                        c = continuum
                        blue = 255 - c
                        red = c
                    elif continuum > 255 and continuum <= 511:
                        c = continuum - 256
                        red = 255 - c
                        green = c
                    else:
                        c = continuum - 512
                        green = 255 - c
                        blue = c

                    self.offscreen_canvas.Fill(red/3, green/3, blue/3)
                    self.offscreen_canvas = self.matrix.SwapOnVSync(self.offscreen_canvas)

        # Main function
        if __name__ == "__main__":
            pulsing_colors = PulsingColors()
            if (not pulsing_colors.process()):
                pulsing_colors.print_help()


##################################################################
    if int(last_line[3])==5:
        while(1):
            with open('/home/pi/Code/PAWS/PAWS-RaspberryPi/data/messages.txt', 'rb') as file:    # /home/pi/Code/ is our PathToRepo
                file.seek(-2, 2)
                while file.read(1) != b'\n':
                    file.seek(-2, 1)
                last_line = file.readline().decode()
            last_line=last_line.split("_")
            if int(last_line[3])!=5:
                #canvas.Clear() 
                break
        
            
##################################################################