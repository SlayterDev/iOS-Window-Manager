source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '9.0'
inhibit_all_warnings!
use_frameworks!

pre_install do |installer|
    # workaround for https://github.com/CocoaPods/CocoaPods/issues/3289
    def installer.verify_no_static_framework_transitive_dependencies; end
end

def all_pods
    # See "Shared" folder for more shared libraries/resources

    # AutoLayout
    pod 'SnapKit'
    # Then API - initialization
    pod 'Then'
    pod 'BSColorUtils', :git => 'https://github.com/SlayterDev/BSColorUtils'
    pod 'RealmSwift'
    
    project 'WindowManager.xcodeproj'

end

target 'WindowManager' do
    all_pods
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
