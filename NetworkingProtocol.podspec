Pod::Spec.new do |s|
  s.name         = "NetworkingProtocol"
  s.version      = "0.1.2"
  s.summary      = 'Simple protocol for URLSession.'
  s.description  = <<-DESC
    Your description here.
  DESC
  s.homepage     = 'https://github.com/mikolaj92/NetworkingProtocol'
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Patryk Mikolajczyk" => "mikpat92@gmail.com" }
  s.ios.deployment_target = "10.0"
  s.osx.deployment_target = "10.13"
  s.watchos.deployment_target = "3.0"
  s.tvos.deployment_target = "10.0"
  s.source       = { :git => ".git", :tag => s.version.to_s }
  s.source_files  = "Sources/**/*"
  s.frameworks  = "Foundation"
end
