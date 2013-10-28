#
# Be sure to run `pod spec lint FunctionalExtensions-ObjC.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# To learn more about the attributes see http://docs.cocoapods.org/specification.html
#
Pod::Spec.new do |s|

  s.name                = "FunctionalExtensions-ObjC"
  s.version             = "0.0.1"
  s.summary             = "Scala-style functional extensions for Apple collection classes."
  s.description         = <<-DESC
                           FunctionalExtensions-ObjC is a static library with several extensions
                           for the Apple collection classes. Currently only tested on iOS 6.0+, but
                           should work on Mac OS X.
                          DESC
  s.homepage            = "https://github.com/autodesk-acg/FunctionalExtensions-ObjC"
  s.license             = 'MIT License'
  s.author              = { "Kent Wong" => "kent.wong@autodesk.com" }
  s.source              = { :git => "https://github.com/autodesk-acg/FunctionalExtensions-ObjC.git" }
  s.platform            = :ios, '6.0'
        
  s.source_files        = 'Source/FunctionalExtensions/*.{h,m}'
  s.ios.frameworks      = 'Foundation'
  s.requires_arc        = true

end
