# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

# Comment the next line if you don't want to use dynamic frameworks
use_frameworks!# :linkage => :static

workspace 'Freshly'
project 'Freshly.xcodeproj'
#project 'Platform/Platform.xcodeproj'
#project 'Domain/Domain.xcodeproj'
#project 'Presentation/Presentation.xcodeproj'
#project 'Common/Common.xcodeproj'

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


#target :Platform do
#  project 'Platform/Platform.xcodeproj'
#
#  target 'PlatformTests' do
#    #use_frameworks! :linkage => :static
#    pod 'RxRelay'
#    pod 'RxSwift'
#    test_pods
#  end
#end
#
#target :Domain do
#  project 'Domain/Domain.xcodeproj'
#
#  #target 'DomainTests' do
#  #end
#end
#
#target :Presentation do
#  project 'Presentation/Presentation.xcodeproj'
#
#  pod 'Instance'
#
#  #target 'PresentationTests' do
#  #end
#end
#
#target :Common do
#  project 'Common/Common.xcodeproj'
#
#  common_pods
#  #target 'CommonTests' do
#  #end
#end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      #config.build_settings['ENABLE_BITCODE'] = 'NO'
      if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_f < 9.0
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
      end
      #config.build_settings['ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES'] = '$(inherited)'
    end
  end
end
