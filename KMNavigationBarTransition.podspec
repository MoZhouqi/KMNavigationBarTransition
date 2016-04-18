Pod::Spec.new do |s|

  s.name         = "KMNavigationBarTransition"
  s.version      = "0.0.7"
  s.summary      = "A drop-in universal library makes transition animations smooth between different navigation bar styles while pushing or popping."

  s.description  = <<-DESC
                   A drop-in universal library helps you to manage the navigation bar styles and makes transition animations smooth between different navigation bar styles while pushing or popping a view controller for all orientations. And you don't need to write any line of code for it, it all happens automatically. 

                   The design concept of the library is that what you only need to care about is the background style of the navigation bar in the *current* view controller, without handling the various background styles while pushing or popping.

                   The library can capture the background style of the navigation bar in the disappearing view controller when pushing, and when you pop back to the view controller, the navigation bar will restore the previous style, so you don't need to consider the background style after popping. And you also don't need to consider it after pushing, because it is the view controller to be pushed that needs to be considered.
                   DESC

  s.homepage     = "https://github.com/MoZhouqi/KMNavigationBarTransition"
  s.screenshots  = "https://raw.githubusercontent.com/MoZhouqi/KMNavigationBarTransition/master/Screenshots/Now2.gif"

  s.license      = "MIT"

  s.author             = { "Zhouqi Mo" => "mozhouqi@gmail.com" }
  s.social_media_url   = "https://twitter.com/MoZhouqi"

  s.platform     = :ios, "7.0"

  s.source       = { :git => "https://github.com/MoZhouqi/KMNavigationBarTransition.git", :tag => s.version }

  s.source_files  = "KMNavigationBarTransition/*.{h,m}"

  s.frameworks = "UIKit"

  s.requires_arc = true

end
