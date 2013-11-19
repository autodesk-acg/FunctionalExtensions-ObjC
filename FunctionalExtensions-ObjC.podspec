#
#  Be sure to run `pod spec lint FunctionalExtensions-ObjC.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "FunctionalExtensions-ObjC"
  s.version      = "0.0.1"
  s.summary      = "Scala-style functional extensions for Apple collection classes."

  s.description  = <<-DESC
                   FunctionalExtensions-ObjC is a library of categories that allows Apple's
                   collection classes to be operated on in a functional manner.
                   The methods added are similar to what is provided by the Scala standard
                   library.
                   DESC

  s.homepage     = "https://github.com/autodesk-acg/FunctionalExtensions-ObjC"
  s.license      = 'MIT'
  s.author       = { "Kent Wong" => "kent.wong@autodesk.com" }
  s.platform     = :ios, '6.0'
  s.source       = { :git => "https://github.com/autodesk-acg/FunctionalExtensions-ObjC.git", :tag => "0.0.1" }
  s.source_files  = 'Source/FunctionalExtensions/*.{h,m}'
  s.requires_arc = true

end
