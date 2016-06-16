Pod::Spec.new do |s|


s.name         = "LBLaunchImageAd"
s.version      = "0.0.1"
s.summary      = "简单易用的开机广告"

s.homepage     = "https://github.com/AllLuckly/LBLaunchImageAd"

s.license      = "MIT"

s.author       = { "liubin" => "lbjobvip@163.com" }

s.platform     = :ios
s.platform     = :ios, "7.0"


s.source       = { :git => "https://github.com/AllLuckly/LBLaunchImageAd.git", :tag => s.version.to_s}


s.source_files  = "LBLaunchImageAd/Lib/LBLaunchImageAd/**/*.{h,m}"


s.requires_arc = true

s.dependency 'SDWebImage', '~> 3.7'

end
