#
#  Be sure to run `pod spec lint MFKCategory.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "MFKCategory"
  s.version      = "0.0.1"
  s.summary      = "个人的私有的分类库"

  s.description  = <<-DESC
  MFKCategory use to project
                   DESC

  s.homepage     = "https://github.com/MeiFengkun/MFKCategory"
  s.ios.deployment_target = "8.0"
  s.platform     = :ios
  s.author             = { "Mei" => "18771886893@163.com" }
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.source       = { :git => "https://github.com/MeiFengkun/MFKCategory.git", :tag => s.version.to_s }

  #若果跟spec文件是同级的文件直接写文件名就好
  s.source_files  = "Classes","单例模板"
 
  s.requires_arc = true


  s.framework  = "UIKit"
  s.dependency "AFNetworking", "~> 3.0.4"

end
