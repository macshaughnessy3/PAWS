# PAWS-iOS

`PAWS-iOS` is the driving app behind the PAWS system. Controlling music, visulization, volume and more.

## Setup and Requirments

Xcode 12 or newer is required to run the PAWS application along with a device on iOS 14 and up. Navigate to the `PAWS/PAWS-iOS/PAWS` folder and run `pod install`. Now, Xcode can compile and run PAWS using a simulator.

## Installing PAWS on a Device

In order to install PAWS on your iPhone you must add a `LocalConfig.xcconfig` to the Config folder

```text
//
//  LocalConfig.xcconfig
//  PAWS
//
//  Created by Mac Shaughnessy on 10/19/21.
//

// Configuration settings file format documentation can be found at:
// https://help.apple.com/xcode/#/dev745c5c974

PRODUCT_BUNDLE_IDENTIFIER = com.YOUR_IDENTIFIER.PAWS
DEVELOPMENT_TEAM = YOUR_TEAM_ID
CODE_SIGN_STYLE = Automatic
```

After making this file, restart xcode then select your target device, build and test the app on your iOS device.

## PAWS Application Overview

### Airplay

In order to stream audio to the Raspberry Pi, Airplay can be used if [shairport-sync](https://github.com/mikebrady/shairport-sync) has been installed following the [PAWS-RaspberryPi README](/PAWS-RaspberryPi/README.md)

### Bluetooth Audio

Alternatively, Bluetooth can be used to steam audio to the Raspberry Pi by opening settings and navigating to `Bluetooth`. Then connecting by selecting the devices name. Ensure the Raspberry Pi is discoverable when attempting to pair.

### Spotify Authorization
In order to build the app in Xcode, the Spotify developer application credentials need to be set. This can be done by selecting product from the menu bar on the top, then selecting Scheme -> Edit Scheme -> Test -> Arguments. From there, environment variables can be added by selecting the + button. Create two variables and name one "CLIENT_ID" and one "CLIENT_SECRET". Use the credentials below for the values.
```bash
# "CLIENT_ID": "6733ea957ba14a66b7ef5ab736ca7500"
# "CLIENT_SECRET": "850e0429e8694ac1a0cfb0f427721bd5"
```

### Onboarding
Onboarding Welcome Page | Onboarding Spotify Login
:-------------------------:|:-------------------------:
<img src="../Assets/PAWS-iOS images/PAWS onboarding intro screen.png" alt="PAWS onboarding intro screen" height="500"/>  |  <img src="../Assets/PAWS-iOS images/PAWS onboarding spotify login screen.png" alt="PAWS onboarding spotify login screen" height="500"/>
**Onboarding BLE Pairing** | **Onboarding Finish Setup**
<img src="../Assets/PAWS-iOS images/PAWS onboarding ble pairing screen.png" alt="PAWS onboarding ble pairing screen" height="500"/>  |  <img src="../Assets/PAWS-iOS images/PAWS onboarding finish setup screen.png" alt="PAWS onboarding finish setup screen" height="500"/>

### Music

Onboarding Welcome Page | Onboarding Spotify Login
:-------------------------:|:-------------------------:
<img src="../Assets/PAWS-iOS images/PAWS music view.png" alt="PAWS music view" height="500"/>   |  <img src="../Assets/PAWS-iOS images/PAWS playlist view.png" alt="PAWS playlist view" height="500"/> 

### Visualizer

Select Visualizer Mode|Create Visualizer Mode | Edit Visualizer Mode
:-------------------------:|:-------------------------:|:-------------------------:|
<img src="../Assets/PAWS-iOS images/PAWS select visualizer view.png" alt="PAWS select visualizer view" height="500"/>  | <img src="../Assets/PAWS-iOS images/PAWS create mode view.png" alt="PAWS create mode view" height="500"/>  |  <img src="../Assets/PAWS-iOS images/PAWS edit mode view.png" alt="PAWS edit mode view" height="500"/>
