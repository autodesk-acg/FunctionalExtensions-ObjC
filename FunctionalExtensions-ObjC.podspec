Pod::Spec.new do |s|

  s.name         = "FunctionalExtensions-ObjC"
  s.version      = "0.0.10"
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
  s.ios.deployment_target = '6.0'
  s.osx.deployment_target = '10.7'
  s.source       = { :git => "https://github.com/autodesk-acg/FunctionalExtensions-ObjC.git", :tag => "0.0.10" }
  s.source_files = 'Classes/*.{h,m}'
  s.frameworks   = 'Foundation'
  s.requires_arc = true

end
