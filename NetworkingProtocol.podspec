Pod::Spec.new do |s|
  s.name         = "NetworkingProtocol"
  s.version      = "0.2.5"
  s.summary      = 'Simple protocol for URLSession.'
  s.description  = <<-DESC
    Simple wrapper for url request and url session.
  DESC
  s.homepage     = 'https://github.com/mikolaj92/NetworkingProtocol'
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Patryk Mikolajczyk" => "mikpat92@gmail.com" }
  s.ios.deployment_target = "10.0"
  s.tvos.deployment_target = "10.0"
  s.source       = { :git => "https://github.com/mikolaj92/NetworkingProtocol.git", :tag => s.version.to_s }
  s.source_files  = "Sources/**/*.{swift}"
  s.frameworks  = "Foundation"
  s.swift_version = "4.2"
end
