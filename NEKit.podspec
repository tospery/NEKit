#
# Be sure to run `pod lib lint NEKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'NEKit'
  s.version          = '0.0.4'
  s.summary          = 'A toolkit for Network Extension Framework.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
						A toolkit for Network Extension Framework.
                       DESC

  s.homepage         = 'https://github.com/tospery/NEKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'tospery' => 'tospery@gmail.com' }
  s.source           = { :git => 'https://github.com/tospery/NEKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.requires_arc = true
  s.static_framework = true
  s.swift_version = '5.0'
  s.ios.deployment_target = '10.0'

  s.source_files = 'NEKit/**/*'

  s.frameworks = 'UIKit', 'NetworkExtension'
  s.dependency 'CocoaAsyncSocket', '~> 7.6.4'
  s.dependency 'CocoaLumberjack/Swift', '~> 3.7.0'
  s.dependency 'MMDB-Swift', '~> 0.5.1'
  s.dependency 'Yaml', '~> 3.4.4'
  s.dependency 'sodium-ios', '~> 0.0.2'

end
