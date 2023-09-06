Pod::Spec.new do |s|
  s.name             = 'iPing'
  s.version          = '0.1.0'
  s.summary          = 'A swift wrapper of fping which is a high performance ping tool with jitter'

  s.description      = <<-DESC
  A swift wrapper of fping which is a high performance ping tool with jitter
                       DESC

  s.homepage         = 'https://github.com/rvndios/iPing'
  s.license          = { :type => 'BSD', :file => 'LICENSE' }
  s.author           = { 'Aravind' => 'aravindscs@gmail.com' }
  s.source           = { :git => 'https://github.com/rvndios/iPing.git', :tag => s.version.to_s }
  s.social_media_url = ''
  s.platform         = :ios, :osx
  s.swift_version = '5.2'

  s.ios.deployment_target = '13.0'
  s.osx.deployment_target = '10.13'

  s.source_files = 'iPing/Pingo.swift', 'iPing/iPing.h', 'fping/*'
  s.public_header_files = 'iPing/iPing.h', 'fping/*.h'
  
  s.frameworks = 'Foundation'

end
