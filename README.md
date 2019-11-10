# ThunderBoard

ThunderBoard is an app for demonstrating the capabilities of the ThunderBoard-React sensor board. It includes Motion, Environment, and I/O demos. ThunderBoard is a native iOS app written in Swift 5.1.

Source code for the [Android app](https://github.com/SiliconLabs/thunderboard-react-android) and [Firebase web interface](https://github.com/SiliconLabs/thundercloud) is also available.

# Screenshots

![Device Selection](Resources/ss_device_selection_sm.png)
![Demo Selection](Resources/ss_demo_selection_sm.png)
![IO Demo](Resources/ss_demo_io_sm.png)
![Motion Demo](Resources/ss_demo_motion_sm.png)

## Bluetooth

Bluetooth Low Energy (BLE) is used to communicate with the ThunderBoard-React device. A device that supports BLE is required to run the ThunderBoard software.

Because the iOS Simulator doesn't support BLE, device interaction is abstracted through protocols. Simulated and Core Bluetooth implementations are injected at runtime, depending on where the app is running. Communication with a real device is not possible inside the simulator, but many of the features of the application can be demonstrated nonetheless.

## Beacons

When powered on, ThunderBoard-React devices broadcast an iBeacon-compatible service, making it possible to be notified of a nearby device automatically.

There are a few things about beacons to keep in mind:

1. Events are only triggered when you ​_cross_​ a region boundary (think entering or leaving a beacon’s broadcast range.

	For example, if you’re using a ThunderBoard and then power cycle it hoping to see a beacon, you won’t receive it. Empirical testing shows that the ThunderBoard needs to be powered off for around 30 seconds before iOS will notify the application that it has left the region. After that, re-entering the region (powering the ThunderBoard on) will produce an alert as expected.

2. You’ll only receive notifications if the iOS device’s screen is on. The BLE radio scans for beacons while the screen is on.

3. Notifications are not displayed if the application is running in the foreground.


## Cloud Streaming

Each ThunderBoard demo can stream realtime data to the cloud. While streaming, the web URL displays live-updating graphs for each characteristic of the demo. After a demo concludes, summary data is shown.

![Motion Demo Streaming](Resources/ss_motion_streaming_sm.png)

The cloud streaming feature is built with [Firebase](https://www.firebase.com). 

### Configuration

In order to enable support, you need to follow this [Tutorial](https://firebase.google.com/docs/ios/setup), and update the configuration values in `ApplicationConfig.swift`. Specifically, the `FirebaseDemoHost` item needs to be updated. Without this value, the streaming feature will be disabled. Once you downloaded `GoogleService-Info.plist` and added it to your project remember, that there are some sensitive data, so adding this file to your repository and publishing it is not recommended.

#### Note

Original application authenticates with Firebase using custom token in such a way, that every instance of the application talks to Firebase backend as one and the same user. I am not sure if this still works. In [tutorial](https://firebase.google.com/docs/auth/ios/custom-auth), it's stated that in order to use custom token authentication one have to generate some key on your backend. Didn't find any code in the Thundercloud backend that would do this.
Anyways, for now I allow for anonymous users. *But in order for this to work you have to allow anonymous users in your Firebase console before you start pushing sensor data into the cloud.*
Maybe later I will try to figure out how to use authentication with custom token.

### Cloud Data

The format for data sent to Firebase is documented inside the web application [README](https://github.com/SiliconLabs/thunderboard-react-web/blob/master/README.md).

### Short URLs

ThunderBoard attempts to shorten all demo URLs with the [is.gd](http://is.gd) URL shortening service. URL stats are not supported, so no credentials are required for the URL shortener. Additional URL shorteners may be easily supported by providing a class conforming to the `UrlShortener` protocol.

# Analytics / Crash reporting setup

You now have to make a decision on which tool to use for analytics and/or crash reporting. Original version of the Thunderboard application uses HockeyApp, so one might think it's ok to stick with this tool, and just upgrade... But...

 HockeyApp was bought by Microsoft and now is replaced/succeeded by App Center. App Center itself is becoming more and more similar in functionality to the Firebase i.e: both do have analytics and crash reporting tools. Now you have to answer the question which one to use? Should you stick with HockeyApp/App Center for crash reporting? Or should you switch to using Firebase, since the application is already using bunch of it's functionality?
 I have prepared this 'DecisionPoint' branch with exactly this problem in mind. It contains `Podfile` that will allow you to use either of the tools. What follows is short description of what one should do to use one of the tools.

 ## App Center (ex. Hockey App)

 1. Sign up for an account at [AppCenter webpage](https://appcenter.ms). If you have a Microsoft account already, you can use that one.
 1. Create your first application, and...
 1. Follow the 'Overview/Getting Started' guide. Don't worry, it won't disappear, so you can return to it at any time.
 1. Remember the character string in step #2 of getting started. It's given in the code (of course it's some random character string not the "you need to copy this string" ;-) ):
 ```
 MSAppCenter.start("<you need to copy this string>", withServices:[
  MSAnalytics.self,
  MSCrashes.self
])
```
 
 **NOTE:** The project is partially prepared for this change: 
 
 - In file `Podfile` just uncomment line `#pod 'AppCenter'` (around line number 10)
 - In file `ApplicationConfig.swift` uncomment the part below and change `get { return nil }` to `get { return "<you need to copy this string>" }`:
```
//    AppCenter Token - (Character string provided by App Center for crash reporting)
//    class var AppCenterToken: String? {
//        get { return nil }
//    }
```
- In file `AppDelegate.swift` uncomment the 3 include lines (lines number 11, 12 and 13) and lines 30-35

## Firebase Analytics/Crashlytics

1. Follow this [tutorial](https://firebase.google.com/docs/crashlytics/get-started?platform=ios)
2. Uncomment lines 14, 15 and 17 in `Podfile` file.

# Building the code

_The ThunderBoard project is written in Swift 5.1, and thus requires Xcode 11.1 or newer._

1. Download Xcode from the Mac App Store or from the [developer tools site](https://developer.apple.com/xcode/downloads/) (if you haven't done that already).
1. Install CocoaPods (`sudo gem install cocoapods`)
1. Clone this project (`git clone https://github.com/MarekSzczypinski/thunderboard-ios.git`)
1. `cd thunderboard-ios`
1. `pod install`
1. Open `ThunderBoard.xcworkspace` in Xcode
1. Build the `Thunderboard` scheme (usually Command+B is enough).
1. Run the application (Command+R)


## Configuration Values

Inside the Xcode project, the `ApplicationConfig.swift` file contains configuration values that need to be provided in order for certain features of the application to be enabled (namely, realtime streaming and Hockey crash reporting). In order to stream realtime data to your own Firebase instance, you'll need to update the following items with your own configuration value:

    // Firebase web app host ("your-application-0001.firebaseapp.com")
    class var FirebaseDemoHost: String {
        get { return "" }
    }

