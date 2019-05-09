platform :ios,'8.0'
use_frameworks!
inhibit_all_warnings!

pre_install do |installer|
    def installer.verify_no_static_framework_transitive_dependencies;
    end
end

target 'HDMasterProject' do
    pod 'NYXImagesKit'            # image各种处理Category
    pod 'IQKeyboardManager', '6.1.1'
    pod 'SDWebImage', '3.7.2'
    pod 'AFNetworking'
    pod 'LBXScan/LBXZBar','~> 2.3'

#    pod 'Dynatrace', :git => 'http://172.16.10.165/midea-common/Dynatrace.git', :branch => 'master'
#    pod 'WeexSDK', :inhibit_warnings => true, :git => 'http://172.16.10.165/midea-common/Weex.git', :branch => 'master'
#    pod 'AppDynamicsAgent'
end
