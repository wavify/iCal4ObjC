Pod::Spec.new do |s|
  s.name         = 'iCal4ObjC'
  s.version      = '1.0'
  s.summary      = 'iCal4ObjC is a Objective-C implementation of the iCalendar specification as defined in RFC2455 for iOS and OS X.'
  s.homepage     = 'https://github.com/cybergarage/iCal4ObjC'
  s.license      = { :type => 'BSD', :file => 'LICENSE.txt' }
  s.author       = 'Satoshi Konno'
  
  s.source       = { :git => 'https://github.com/cybergarage/iCal4ObjC.git', :tag => s.version.to_s }
  
  s.ios.deployment_target = '5.1'
  s.ios.source_files = 'Shared/*.{h,m}', 'iOS/*.h'
  s.ios.public_header_files = 'Shared/*.h', 'iOS/*.h'
  s.osx.deployment_target = '10.6'
  s.ios.source_files = 'Shared/*.{h,m}', 'OSX/*.h'
  s.osx.public_header_files = 'Shared/*.h', 'OSX/*.h'
  
  s.requires_arc = true
end
