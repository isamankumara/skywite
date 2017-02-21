Pod::Spec.new do |s|
  s.name             = "SkyWite"
  s.version          = "1.3"
  s.summary          = "Open Source Request handeling/managing on iOS snf OS X"
  s.description      = "SkyWite is a open-source and highly versatile multi-purpose frameworks. Clean code and sleek features make SkyWite an ideal choice. Powerful high-level networking abstractions built into Cocoa. It has a modular architecture with well-designed, feature-rich APIs that are a joy to use. Achieve your deadlines by using SkyWite. You will save Hundred hours. Start development using Skywite. Definitely you will be happy....! yeah.."
  s.homepage         = "https://github.com/isamankumara/skywite"
  s.license          = 'MIT'
  s.author           = { "saman kumara" => "me@isamankumara.com" }
  s.source           = { :git => "https://github.com/isamankumara/skywite.git", :tag => s.version.to_s, :submodules => true }

  s.requires_arc = true
  s.ios.deployment_target = "9.0"
  s.tvos.deployment_target = '9.0'
  #s.watchos.deployment_target = '2.0'
  s.osx.deployment_target = '10.11'

#s.source_files = 'SWNetworking/SWNetworking.h'
# s.public_header_files = 'SWNetworking/*.h'
  
  s.subspec 'File' do |ss|
  	ss.source_files		= 'SkyWite/File'
  end
  
  s.subspec 'ResponseType' do |ss|
  	ss.source_files		= 'SkyWite/ResponseType'
    ss.dependency 'SkyWite/File'
  end
  
  s.subspec 'Reachability' do |ss|
  	ss.source_files		= 'SkyWite/Reachability'
  end
  
  s.subspec 'SWRequest' do |ss|
  	ss.source_files		= 'SkyWite/SWRequest'
  	ss.dependency 'SkyWite/ResponseType'
  	ss.dependency 'SkyWite/File'
  	ss.dependency 'SkyWite/Reachability'
  end

  s.subspec 'UIKit+SkyWite' do |ss|
  	ss.source_files		= 'SkyWite/UIKit+SkyWite'
  	ss.dependency 'SkyWite/SWRequest'
  	ss.dependency 'SkyWite/ResponseType'

  end
  

  s.frameworks = 'SystemConfiguration'
end
