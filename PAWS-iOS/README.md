# PAWS-iOS

`PAWS-iOS` is the driving app behind the PAWS system. Controlling music, visulization, volume and more.

## Setup and Requirments

Xcode 12 or newer is required to run the PAWS application along with a device on iOS 14 and up.

1. Navigate to the `PAWS/PAWS-iOS/PAWS` folder and run `pod install`
2. Install swift resources

After these steps, Xcode can compile and run PAWS using a simulator.

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