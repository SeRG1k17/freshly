# Uncomment the next line to define a global platform for your project
platform :ios, '12.0'

# Comment the next line if you don't want to use dynamic frameworks
use_frameworks!# :linkage => :static

workspace 'Freshly'
project 'Freshly.xcodeproj'

def common_pods
  pod 'RxRelay'
  pod 'RxSwift'
  pod 'XCoordinator/RxSwift'
  pod 'RxDataSources'
  pod 'Moya/RxSwift'
  pod 'RxCocoa'
end

def test_pods
  pod 'RxTest'
end

target :Freshly do
  project 'Freshly.xcodeproj'
  pod 'RxSwift'
  pod 'XCoordinator/RxSwift'
end

target :Common do
  project 'Freshly.xcodeproj'
  pod 'RxSwift'
  pod 'RxRelay'
end

target :CommonTests do
  project 'Freshly.xcodeproj'
  test_pods
end

target :Presentation do
  project 'Freshly.xcodeproj'
  pod 'RxRelay'
  pod 'RxSwift'
  pod 'XCoordinator/RxSwift'
  pod 'RxDataSources'
  pod 'RxCocoa'
  pod 'Instance'
end

target :Domain do
  project 'Freshly.xcodeproj'
  pod 'RxSwift'
end

target :Platform do
  project 'Freshly.xcodeproj'
  pod 'RxRelay'
  pod 'RxSwift'
  pod 'Moya/RxSwift'
end

target :PlatformTests do
  project 'Freshly.xcodeproj'
  test_pods
end

target :FreshlyTests do
  project 'Freshly.xcodeproj'
  test_pods
end

target :FreshlyUITests do
  project 'Freshly.xcodeproj'
  
  pod 'RxRelay'
  pod 'RxSwift'
  pod 'XCoordinator/RxSwift'
  pod 'RxDataSources'
  pod 'RxCocoa'
  pod 'Instance'
end


post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ENABLE_BITCODE'] = 'NO'
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
      config.build_settings['ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES'] = '$(inherited)'
    end
  end
end
