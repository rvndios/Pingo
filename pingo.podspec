Pod::Spec.new do |s|
  s.name             = 'pingo'
  s.version          = '1.0.2'
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

  s.source_files = 'pingo/Pingo.swift', 'pingo/pingo.h', 'pingo/fping/*'
  s.public_header_files = 'pingo/pingo.h', 'pingo/fping/*.h'
  
  s.frameworks = 'Foundation'

end
