#
# Be sure to run `pod lib lint ProgressController.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "RxAVPlayer"
  s.version          = "1.0.0"
  s.summary          = "A progress view that leverages UIPresentationController rather than inserting views into your window/view hierarchy."
  s.homepage         = "https://github.com/YayNext/ProgressController"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Patrick Mick" => "patrickmick1@gmail.com" }
  s.source           = { :git => "https://github.com/pmick/RxAVPlayer", :tag => s.version.to_s }
  s.social_media_url = "http://twitter.com/patrickmick"

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Source/*.swift'

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'RxSwift', '~> 2.3'
  s.dependency 'RxCocoa', '~> 2.3'
end
