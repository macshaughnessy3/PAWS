# PAWS-iOS

`PAWS-iOS` is the driving app behind the PAWS system. Controlling music, visualization, volume and more.

## Setup and Requirements

Xcode 12 or newer is required to run the PAWS application along with a device on iOS 14 and up. Navigate to the `PAWS/PAWS-iOS/PAWS` folder and run `pod install`. Now, Xcode can compile and run PAWS using a simulator.

## Spotify Authorization

In order to build the app in Xcode, the Spotify developer application credentials need to be set. This can be done by selecting product from the menu bar on the top, then selecting Scheme -> Edit Scheme -> Test -> Arguments. From there, environment variables can be added by selecting the + button. Create two variables and name one "CLIENT_ID" and one "CLIENT_SECRET". Use the credentials below for the values. Alternatively, you can create your own [spotify developer account](https://developer.spotify.com) and use your own credentials when building the application.

```text
"CLIENT_ID": "6733ea957ba14a66b7ef5ab736ca7500"
"CLIENT_SECRET": "850e0429e8694ac1a0cfb0f427721bd5"
```

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

### Onboarding

Onboarding Welcome Page | Onboarding Spotify Login
:-------------------------:|:-------------------------:
![PAWS onboarding intro screen](/Assets/PAWS-iOS%20images/PAWS%20onboarding%20intro%20screen.png)  |  ![PAWS onboarding spotify login screen](/Assets/PAWS-iOS%20images/PAWS%20onboarding%20intro%20screen.png)
**Onboarding BLE Pairing** | **Onboarding Finish Setup**
![PAWS onboarding finish setup screen](/Assets/PAWS-iOS%20images/PAWS%20onboarding%20ble%20pairing%20screen.png) | ![PAWS onboarding ble pairing screen](/Assets/PAWS-iOS%20images/PAWS%20onboarding%20finish%20setup%20screen.png)

### Music

Onboarding Welcome Page | Onboarding Spotify Login
:-------------------------:|:-------------------------:
![PAWS music view](/Assets/PAWS-iOS%20images/PAWS%20music%20view.png) | ![PAWS playlist view](/Assets/PAWS-iOS%20images/PAWS%20playlist%20view.png)

### Visualizer

Select Visualizer Mode|Create Visualizer Mode | Edit Visualizer Mode
:-------------------------:|:-------------------------:|:-------------------------:|
![PAWS select visualizer view](/Assets/PAWS-iOS%20images/PAWS%20select%20visualizer%20view.png) | ![PAWS create mode view](/Assets/PAWS-iOS%20images/PAWS%20create%20mode%20view.png) |  ![PAWS edit mode view](/Assets/PAWS-iOS%20images/PAWS%20edit%20mode%20view.png)
