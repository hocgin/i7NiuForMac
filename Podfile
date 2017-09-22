# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'
platform :osx, '10.11'

target 'i7NiuForMac' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for i7NiuForMac
  pod "Qiniu", "~> 7.1"
  pod "CryptoSwift"
  pod "SwiftyJSON"
  pod "PromiseKit", "~> 4.0"

  target 'i7NiuForMacTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'i7NiuForMacUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

# 由于我使用swift3，需要配置一下编译设置
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
    end
  end
end
