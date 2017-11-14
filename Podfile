source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target 'FoodDelivery' do
    pod 'Alamofire', '~> 4.5'
    pod 'AlamofireImage', '~> 3.3'
    pod 'MBProgressHUD', '~> 1.0.0'

  # Pods for FoodDelivery

  target 'FoodDeliveryTests' do
    inherit! :search_paths
    pod 'Quick'
    pod 'Nimble'
  end

  target 'FoodDeliveryUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

# Manually making Quick compiler version be swift 3.2
post_install do |installer|
    installer.pods_project.targets.each do |target|
        if target.name == 'Quick' || target.name == 'Nimble'
            print "Changing Quick swift version to 3.2\n"
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '3.2'
            end
        end
    end
end
