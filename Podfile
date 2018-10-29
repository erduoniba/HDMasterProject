platform :ios,'8.0'
use_frameworks!
inhibit_all_warnings!

pre_install do |installer|
    def installer.verify_no_static_framework_transitive_dependencies;
    end
end

target 'HDMasterProject' do
    pod 'NYXImagesKit'            # image各种处理Category
    pod 'IQKeyboardManager', '6.0.4'
    pod 'SDWebImage', '3.7.2'
    pod 'AFNetworking'
end
