#
# Be sure to run `pod lib lint RCSceneKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RCSceneKit'
  s.version          = '0.1.0'
  s.summary          = 'RCSceneKit of RongCloud Scene.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
			RongCloud RCSceneKit SDK for iOS.
                       DESC

  s.homepage         = 'https://github.com/rongcloud-community'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license      = { :type => "Copyright", :text => "Copyright 2022 RongCloud" }
  s.author           = { '彭蕾' => 'penglei1@rongcloud.cn' }
  s.source           = { :git => 'https://github.com/rongcloud-community/rongcloud-scene-kit-ios.git', :tag => s.version.to_s }

  s.social_media_url = 'https://www.rongcloud.cn/devcenter'

  s.ios.deployment_target = '11.0'

  # RCSPageContainer
  s.subspec 'RCSPageContainer' do |container|
    # 1 - source
    container.source_files = 'RCSceneKit/RCSPageContainer/Classes/**/*'
    container.prefix_header_file = 'RCSceneKit/RCSPageContainer/Classes/Common/RCSPageContainerPrefixHeader.pch'
    
    # 2 - dependency
    container.dependency 'RCSceneBaseKit'
    container.dependency 'Masonry'
    container.dependency 'SVProgressHUD'
    container.dependency 'MJRefresh'
    container.dependency 'SDWebImage'
    
  end
  
  # RCSPageFloater
  s.subspec 'RCSPageFloater' do |floater|
    # 1 - source
    floater.source_files = 'RCSceneKit/RCSPageFloater/Classes/**/*'
    floater.resource_bundles = {
         'RCSPageFloater' => ['RCSceneKit/RCSPageFloater/Assets/**/*']
       }
    floater.prefix_header_file = 'RCSceneKit/RCSPageFloater/Classes/Common/RCSPageFloaterPrefixHeader.pch'
    
    # 2 - dependency
    floater.dependency 'RCSceneBaseKit'
    floater.dependency 'Masonry'
    floater.dependency 'SDWebImage'
    floater.dependency "Pulsator"
    
  end

end
