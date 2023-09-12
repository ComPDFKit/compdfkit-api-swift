Pod::Spec.new do |s|

  s.name         = "compdfkit-api-swift"
  s.version      = "1.3.2"
  s.summary      = "compdfkit-api-swift."

  s.description  = <<-DESC
                    compdfkit-api-swift
                   DESC

  s.homepage     = "https://github.com/ComPDFKit/compdfkit-api-swift"

  s.license      = { :type => "MIT", :file => "FILE_LICENSE" }

  s.author       = "Kdan"

   s.ios.deployment_target = "10.0"
   s.osx.deployment_target = "10.13"

  s.source       = { :git => "git@github.com:ComPDFKit/compdfkit-api-swift.git", :tag => s.version.to_s }

  s.source_files  = "compdfkit-api-swift/compdfkit-api-swift/src/**/*.swift"

  s.requires_arc = true

  s.xcconfig = { "GENERATE_INFOPLIST_FILE" => "YES" }
end
