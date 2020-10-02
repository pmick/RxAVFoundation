#
# Be sure to run `pod lib lint ProgressController.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "RxAVFoundation"
  s.version          = "3.1.0"
  s.summary          = "Functional Reactive (RxSwift) extensions for AVFoundations"
  s.homepage         = "https://github.com/pmick/RxAVFoundation"
  s.license          = 'MIT'
  s.author           = { "Patrick Mick" => "patrickmick1@gmail.com" }
  s.source           = { :git => "https://github.com/pmick/RxAVFoundation.git", :tag => s.version.to_s }
  s.social_media_url = "http://twitter.com/patrickmick"

  s.swift_version = '5.0'
  s.ios.deployment_target = '8.0'
  s.tvos.deployment_target = '9.0'
  s.requires_arc = true

  s.source_files = 'Sources/RxAVFoundation/*.swift'

  s.dependency 'RxSwift', '~> 5.0'
  s.dependency 'RxCocoa', '~> 5.0'
end
