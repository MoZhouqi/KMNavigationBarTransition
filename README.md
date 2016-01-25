KMNavigationBarTransition
============

A drop-in universal library makes transition animations smooth between different navigation bar styles while pushing or popping a view controller for all orientations. And you don't need to write any line of code for it, it all happens automatically.

The library can "capture" the background state of the navigation bar in the disappeared view controller. So what you only need to care about is the background state of the navigation bar in the *current* view controller, without handling the various background states while pushing or popping.

## Screenshot

### Before

![KMNavigationBarTransition](https://raw.githubusercontent.com/MoZhouqi/KMNavigationBarTransition/master/Screenshots/Before1.gif)
![KMNavigationBarTransition](https://raw.githubusercontent.com/MoZhouqi/KMNavigationBarTransition/master/Screenshots/Before2.gif)

### Now

![KMNavigationBarTransition](https://raw.githubusercontent.com/MoZhouqi/KMNavigationBarTransition/master/Screenshots/Now1.gif)
![KMNavigationBarTransition](https://raw.githubusercontent.com/MoZhouqi/KMNavigationBarTransition/master/Screenshots/Now2.gif)

## Installation

### CocoaPods

You can install the latest release version of CocoaPods with the following command:

```bash
$ gem install cocoapods
```

Simply add the following line to your Podfile:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '7.0' 

pod 'KMNavigationBarTransition', '~> 0.0.4' 
```

Then, run the following command:

```bash
$ pod install
```

## Requirements

- iOS 7.0+

## Known Issues

On iOS 8.2 or below, if you make the navigation bar transparent and set the `barTintColor` for the background color, and then change the `barTintColor`, the background color of the navigation bar will flash when the interactive transition is cancelled.

To avoid this from happening, I recommend you to use `setBackgroundImage:forBarMetrics:` instead of `setBarTintColor:` to change the navigation background color. 

## License

KMNavigationBarTransition is released under the MIT license. See LICENSE for details.
