Pod::Spec.new do |s|

  s.name         = "KMNavigationBarTransition"
  s.version      = "0.0.1"
  s.summary      = "A drop-in universal library makes transition animations smooth between different navigation bar styles while pushing or popping."

  s.description  = <<-DESC
                   A drop-in universal library makes transition animations smooth between different navigation bar styles while pushing or popping a view controller. And you don't need to write any line of code for it, it all happens automatically.

                   The library can "capture" the background state of the navigation bar in the disappeared view controller. So what you only need to care about is the background state of the navigation bar in the *current* view controller, without handling the various background states while pushing or popping.
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
