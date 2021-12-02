# Hardware Overview

The hardware used and steps to assemble our projects housing are described in the following document. This includes design files, components and assembly steps for the various circuits in our system.

## Components

A comprehensive list of build materials, files and settings for tools used in the construction of our speaker and housing.
Hardware | Links
---| ---
Raspberry Pi 4  | [Canakit Raspberry Pi 4](https://www.canakit.com/raspberry-pi-4-starter-kit.html)
AdaFruit 64x32 LED Matrix | [AdaFruit 64x32 LED Matrix](https://www.adafruit.com/product/2278)
AdaFruit RGB Matrix HAT | https://www.amazon.com/Adafruit-RGB-Matrix-HAT-Raspberry/dp/B00SK69C6E/ref=sr_1_1?keywords=Adafruit+RGB+Matrix+HAT&qid=1638466078&sr=8-1
Massive Audio MX Series Car Coaxial Speakers | [4" Massive Audio MX Series Car Coaxial Speakers](https://www.amazon.com/Massive-Audio-MX4-Speakers-Speakers/dp/B073JJ7F4W/ref=sr_1_3?dchild=1&keywords=30w+4+inch+car+speakers&qid=1632342682&sr=8-)
TalentCell Rechargeable Battery Pack | [TalentCell Rechargeable Battery Pack](https://www.amazon.com/TalentCell-Rechargeable-12000mAh-Multi-led-indicator/dp/B00ME3ZH7C/ref=sr_1_6?dchild=1&keywords=rechargeable+battery+12v&qid=1632341218&sr=8-6)
Battery Indicator Light | [Battery Indicator Light](https://www.amazon.com/Battery-Capacity-Indicator-Lead-Acid-Motorcycle/dp/B07V2KMQGQ/ref=sr_1_6?dchild=1&keywords=battery+indicator&qid=1633471326&sr=8-6)
AdaFruit Stereo 20W Class D Audio Amplifier | [AdaFruit Stereo 20W Class D Audio Amplifier](https://www.amazon.com/Stereo-20W-Class-Audio-Amplifier/dp/B00SK8OH30/ref=sr_1_5?dchild=1&keywords=adafruit+audio+amplifier&qid=1632341178&sr=8-5)
Portable Power Button | [Portable Power Button](https://www.amazon.com/s?k=power+button&ref=nb_sb_noss_2)
Re-charging Switch and Plug Terminal | [Re-charging Switch and Plug Terminal](https://www.amazon.com/BIQU-Rocker-Switch-Socket-Module/dp/B07KS2TQ45/ref=sr_1_10?dchild=1&keywords=Mounted+power+button&qid=1633471706&sr=8-10)
AdaFruit Electret Microphone Amplifier | [AdaFruit Electret Microphone Amplifier](https://www.amazon.com/Adafruit-Electret-Microphone-Amplifier-Adjustable/dp/B00K9M6S1O/ref=sr_1_3?dchild=1&keywords=adafruit+1713&qid=1632090401&sr=8-3)
3 pieces of 2'x 2' x 3/8" wood | [Lowe's 3 pieces of 2'x 2' x 3/8" wood](https://www.lowes.com/pd/1-4-in-Common-Pine-Sanded-Plywood-Application-as-2-x-2/1000068959)

## Design Files

The initial concepts for our projects housing looked as follows:

<!-- ![Hand Sketches](https://github.com/macshaughnessy3/PAWS/blob/main/Hardware/Led%20matrix%20-%2032%20x%2064%20%20(10”%20x%205”).jpeg) -->
<img src="Led matrix - 32 x 64  (10” x 5”).jpeg" alt="drawing" width="500"/>

These choices were  narrowed down and we opted for the first design where the box would be 11" x 11" x 1'10". This led us to use adobe illustrator to design a file for a laser cutter. This file includes cutouts designed to the cut at desired locations as well as add engraving for our team name. These design files are `LASER CUT 1.ai`, `LASER CUT 2.ai`, and `LASER CUT 3.ai`.

## Assembly

### 1. Laser Cutting

The `LASER CUT 1.ai`, `LASER CUT 2.ai`, and `LASER CUT 3.ai` files were used for cutting and engraving our box pictured below. These files were sent to the laser cutter using various settings such as power and speed to engrave our pieces off wood. It is important to ensure the wood is perfectly flat in the cutting bed.

### 2. Speaker circuit

The speaker uses a 12-V Class D Audio Amplifier to power 2 30W speakers. The output volume is set digitally over an I2C communication connection.

### 3. Raspberry Pi Circuit

The Raspberry Pi is connected to a 5V battery that is capable of supplying 3 Amps steadily. All outputs are connected to Raspberry Pi via GPIO pins.

### 4. Matrix Circuit

The LED matrix is connected via the RGB matrix hat that connects 5V power and a decoded signal to the matrix.