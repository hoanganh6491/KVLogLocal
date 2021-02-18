Pod::Spec.new do |s|

  s.name             = "KVLogLocal"
  s.version          = "1.0.1"
  s.summary          = "iOS library allows you save log at local realm db and publish as logs.txt file"
  s.description      = <<-DESC
                        iOS library allows you save log at local realm db and publish as logs.txt file.
                       DESC
  s.homepage         = "https://kiotviet.vn/"
  s.license          = { :type => "MIT", :file => "LICENSE" }
  s.author           = { "Anh Vu Hoang" => "anh.vh@citigo.com.vn" }
  s.source           = { :git => "https://github.com/hoanganh6491/KVLogLocal.git", :tag => s.version.to_s }

  s.platform     = :ios, '9.0'
  s.requires_arc = true

  s.source_files = 'KVLogLocal/KVLogLocalHelper/**/*.{swift}'

  s.frameworks = 'Foundation'
  s.frameworks = 'UIKit'
  s.dependency 'RealmSwift', '~> 4.1.1'
  s.dependency 'SwiftyUserDefaults', '~> 3.0.0'
  s.dependency 'Alamofire', '~> 4.4'
  s.dependency 'SwiftyJSON'

end
