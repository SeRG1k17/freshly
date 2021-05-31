#
# Be sure to run `pod lib lint RxTestable.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RxTestable'
  s.version          = '0.1.0'
  s.summary          = 'A short description of RxTestable.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/sp@voir.me/RxTestable'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.author           = { 'Sergey Pugach' => 'pugach.s17@gmail.com' }
  s.source           = { :git => 'https://github.com/serg1k17/RxTestable.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'Sources/**/*.{swift}'
  s.frameworks = 'XCTest'
  s.dependency 'RxTest'
  s.dependency 'RxRelay'
  
end
