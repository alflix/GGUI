Pod::Spec.new do |s|
	s.name                  = 'GGUI'
	s.version               = '0.9.0'
	s.summary               = 'UIKit Extensions In Swift'
	
	s.homepage              = 'https://github.com/alflix/GGUI'
	s.license               = { :type => 'Apache-2.0', :file => 'LICENSE' }
	
	s.authors               = { 'John' => 'jieyuanz24@gmail.com' }
	s.source                = { :path => 'Source' }	
	
	s.swift_version         = "4.2"
	s.ios.deployment_target = "9.0"
	s.platform              = :ios, '9.0'
	
	s.module_name           = 'GGUI'
	s.requires_arc          = true
	s.source_files          = 'Source/**/*.swift'
	s.resources             = 'Resources/**/*'

end