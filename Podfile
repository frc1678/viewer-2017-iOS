# Uncomment this line to define a global platform for your project
# platform :ios, '6.0'

use_frameworks!
source 'https://github.com/CocoaPods/Specs.git'

target 'ios-viewer' do
    post_install do |installer|
        installer.pods_project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '3.0'
                config.build_settings['MACOSX_DEPLOYMENT_TARGET'] = '10.10'
            end
            if target.name == "Pods-CurrentMatch-AFNetworking"   # EMToday should be the Extension target name
                target.build_configurations.each do |config|
                    config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= ['$(inherited)', 'AF_APP_EXTENSIONS=1']
                end
            end
        end
    end
    pod 'Firebase/Core'
    #pod 'Firebase/Auth'
    #pod 'FirebaseUI', '~> 0.4'
    pod 'MWPhotoBrowser'
    pod 'Firebase/Database'
    pod 'Firebase/Storage'
    pod 'JBChartView'
    pod 'SwiftyJSON'
    pod 'HanekeSwift', :git => 'https://github.com/Haneke/HanekeSwift', :branch => 'feature/swift-3'
    pod 'Instabug'
    pod 'MWPhotoBrowser'
    pod 'HockeySDK'

end

target 'Current Match' do
    pod 'Firebase/Core'
    pod 'Firebase/Database'
    pod 'HanekeSwift', :git => 'https://github.com/Haneke/HanekeSwift', :branch => 'feature/swift-3'
end

target 'CurrentMatch' do
    pod 'Firebase/Core'
    pod 'Firebase/Database'
    pod 'HanekeSwift', :git => 'https://github.com/Haneke/HanekeSwift', :branch => 'feature/swift-3'
end


