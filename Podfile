platform :ios,'8.0'
use_frameworks!
inhibit_all_warnings!

pre_install do |installer|
    def installer.verify_no_static_framework_transitive_dependencies;
    end
end

target 'HDMasterProject' do
    pod 'NYXImagesKit', '2.3'            # image各种处理Category
    pod 'IQKeyboardManager', '6.1.1'
    pod 'AFNetworking', '3.2.1'
    pod 'LBXScan/LBXZBar','~> 2.3'
    
    pod 'CocoaLumberjack', '~> 3.5.3'
    
    pod 'MLeaksFinder', '1.0.0'
    
    pod 'SDWebImage', '4.2.1'
    pod 'MJRefresh', '3.2.0'
    pod 'HDBaseProject', :git => 'https://github.com/erduoniba/HDBaseProject.git'

#    pod 'Dynatrace', :git => 'http://172.16.10.165/midea-common/Dynatrace.git', :branch => 'master'
#    pod 'WeexSDK', :inhibit_warnings => true, :git => 'http://172.16.10.165/midea-common/Weex.git', :branch => 'master'
#    pod 'AppDynamicsAgent'
end
