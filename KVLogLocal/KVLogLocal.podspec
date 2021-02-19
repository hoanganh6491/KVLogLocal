Pod::Spec.new do |s|

# 1
s.platform = :ios
s.ios.deployment_target = '12.0'
s.name = "KVLogLocal"
s.summary = "KVLogLocal : simple log with realm"
s.requires_arc = true

# 2
s.version = "0.1.1"

# 3
s.license = { :type => "MIT", :file => "LICENSE" }

# 4 - Replace with your name and e-mail address
s.author = { "Anh Vu" => "hoanganh6491@gmail.com" }

# 5 - Replace this URL with your own GitHub page's URL (from the address bar)
s.homepage = "https://github.com/hoanganh6491/KVLogLocal"

# 6 - Replace this URL with your own Git URL from "Quick Setup"
s.source = { :git => "https://github.com/hoanganh6491/KVLogLocal.git",
             :tag => "#{s.version}" }

# 7
s.framework = "UIKit"
s.framework = "Foundation"
s.dependency 'RealmSwift', '~> 4.1.1'
s.dependency 'SwiftyUserDefaults', '~> 3.0.0'
s.dependency 'Alamofire', '~> 4.4'
s.dependency 'SwiftyJSON'

# 8
s.source_files = "KVLogLocal/**/*.{swift}"

# 9
#s.resources = "KVLogLocal/**/*.{png,jpeg,jpg,storyboard,xib,xcassets}"

# 10
s.swift_version = "4.2"

end
