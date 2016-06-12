#
#  Be sure to run `pod spec lint LBLaunchImageAd.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|



  s.name         = 'LBLaunchImageAd'
  s.version      = '0.0.1'
  s.summary      = 'IOS Paul started advertising function'


  s.homepage     = 'https://github.com/AllLuckly/LBLaunchImageAd'


  s.license      = "MIT"

  s.author       = { 'liubin' => 'lbjobvip@163.com' }
 


   s.platform     = :ios, '7.0'





  s.source       = { :git => 'https://github.com/AllLuckly/LBLaunchImageAd.git', :tag => '0.0.1' }




  s.source_files  = 'LBLaunchImageAd/**/*.{h,m}'



  s.framework  = 'UIKit'


  s.dependency 'SDWebImage', '~> 3.7.6'

end
