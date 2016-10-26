#
#  Be sure to run `pod spec lint LearnEverydays.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

s.name = 'LearnEverydays'
s.version = '1.0.0'
s.license = 'MIT'
s.summary = 'A Text in iOS.'
s.homepage = 'https://github.com/zhoubo6419/LearnEverydays'
s.authors = { 'zhoubo6419' => '1436640281@qq.com' }
s.source = { :git => "https://github.com/zhoubo6419/LearnEverydays.git", :tag => "1.0.0"}
s.requires_arc = true
s.ios.deployment_target = '7.0'
s.source_files  = "LearnEverydays/*.{h,m}"
end
