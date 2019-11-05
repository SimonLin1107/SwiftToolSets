Pod::Spec.new do |spec|
spec.name        = "SwiftToolSets"
spec.version        = "0.0.3"
spec.swift_version    = '5.0'
spec.summary        = "Swift Tool Sets"

spec.description    = <<-DESC
ViewTools
ImageTools
StringTools
UIButtonClosure
InternetTools
SecKeyTools
DESC

spec.homepage        = "https://github.com/SimonLin1107/SwiftToolSets"
spec.license        = { :type => "MIT", :file => "LICENSE" }
spec.author        = { "SimonLin1107" => "linsimon1107@gmail.com" }
spec.platform        = :ios, "10.0"
spec.source        = { :git => "https://github.com/SimonLin1107/SwiftToolSets.git", :tag => "#{spec.version}" }
spec.source_files    = "SwiftToolSets/**/*.{h,m,swift}"
end
