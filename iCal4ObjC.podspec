Pod::Spec.new do |s|
  s.name         = 'iCal4ObjC'
  s.version      = '1.0'
  s.summary      = 'iCal4ObjC is a Objective-C implementation of the iCalendar specification as defined in RFC2455. It supports to read or write the components of iCalendar in the stream easily.'
  s.homepage     = 'https://github.com/cybergarage/iCal4ObjC'
  s.license      = { :type => 'BSD', :file => 'LICENSE' }
  s.author       = 'Satoshi Konno'
  
  s.source       = { :git => 'https://github.com/cybergarage/iCal4ObjC.git', :tag => s.version.to_s }
  
  s.ios.deployment_target = '5.1'
  s.osx.deployment_target = '10.6'
  
  s.source_files = 'iCalObjCSDK/*.{h,m}'
  s.public_header_files = 'iCalObjCSDK/*.h'
  s.requires_arc = true
end
