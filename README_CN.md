KMNavigationBarTransition
============

一个用来统一管理导航栏转场以及当 push 或者 pop 的时候使动画效果更加顺滑的通用库，并且同时支持竖屏和横屏。你不用为这个库写一行代码，所有的改变都悄然发生。

## 效果图

### 之前

![KMNavigationBarTransition](https://raw.githubusercontent.com/MoZhouqi/KMNavigationBarTransition/master/Screenshots/Before1.gif)
![KMNavigationBarTransition](https://raw.githubusercontent.com/MoZhouqi/KMNavigationBarTransition/master/Screenshots/Before2.gif)

### 现在

![KMNavigationBarTransition](https://raw.githubusercontent.com/MoZhouqi/KMNavigationBarTransition/master/Screenshots/Now1.gif)
![KMNavigationBarTransition](https://raw.githubusercontent.com/MoZhouqi/KMNavigationBarTransition/master/Screenshots/Now2.gif)

## 介绍

本库的设计理念是使用者只用关心*当前* view controller 导航栏的背景样式，而不用在 push 或者 pop 的时候处理各种背景样式。

当 push 的时候本库会保存消失的 view controller 导航栏的背景样式，当 pop 回去后就会还原成以前的样式，因此你不用考虑 pop 后各种导航栏样式改变的情况。同时你也不必考虑 push 后的情况，因为这个是被 push 的 view controller 本身需要考虑的。

## 使用说明

使用本库时不用 import 任何头文件，全部通过 [Method Swizzling](http://nshipster.com/method-swizzling/) 在底层做了处理。

推荐在所有 view controller 基类的 `viewDidLoad` 里设置默认的导航栏背景样式，当需要改变时，一般也只需要在*当前* view controller 的 `viewDidLoad` 里去操作。

下面是一些设置导航栏背景样式的建议，具体的用法可以参见 Example。

- 设置导航栏背景样式有两个方法，`setBackgroundImage:forBarMetrics:` 和 `setBarTintColor:`。推荐使用前者，具体原因参见[已知问题](#已知问题)。

- `translucent` 这个属性的值在初始化后尽量不要随意修改，否则容易发生界面的布局错乱。

- 当`translucent` 为 `true` 时，可以用以下方法使导航栏背景透明：

  ```swift
  navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
  navigationController?.navigationBar.shadowImage = UIImage() // shadowImage 就是那根 1px 的细线
  ```

- 当需要改变导航栏背景色的透明度时，可以改变 `setBackgroundImage:forBarMetrics:` 中 image 的 alpha 值。

- 如果需要显示或隐藏导航栏，一般只需要在 `viewWillAppear:` 里设置，代码如下：

  ```swift
  override func viewWillAppear(animated: Bool) {
      super.viewWillAppear(animated)
      navigationController?.setNavigationBarHidden(hidden, animated: animated)
  }
  ```

  最好不要在 `viewWillDisappear:` 或者其他发生跳转的方法里去设置，这样不容易管理。还是那句宗旨，你只需要关心*当前* view controller 导航栏的样式。

  当然最好还是不要隐藏导航栏，因为和系统边缘左滑返回手势一起使用可能会触发一些苹果的 bug。

## 安装

### CocoaPods

可以用以下命令来安装最新版的 CocoaPods:

```bash
$ gem install cocoapods
```

在 podfile 中加入以下代码:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '7.0' 

pod 'KMNavigationBarTransition', '~> 0.0.5' 
```

然后在终端运行以下命令:

```bash
$ pod install
```

## 基本要求

- iOS 7.0+

## 已知问题

在 iOS 8.2 或者之前的版本，如果导航栏的 `translucent` 值为 `true` 时，用 `barTintColor` 去设置导航栏的背景样式，然后改变 `barTintColor` 的颜色，那么当边缘左滑返回手势取消的时候导航栏的背景色会闪烁。

为了避免这种情况发生，推荐用 `setBackgroundImage:forBarMetrics:` 来改变导航栏的背景样式。

## 许可证

KMNavigationBarTransition 是基于 MIT 许可证下发布的，详情请参见 LICENSE。