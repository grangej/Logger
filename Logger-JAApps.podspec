Pod::Spec.new do |spec|
	spec.name		= 'Logger-JAApps'
	spec.version	= '5.0.5'
	spec.license	= 'MIT'
	spec.homepage	= 'https://github.com/grangej/Logger'
	spec.authors	= { 'John Grange' => 'john@sd-networks.net' }
	spec.summary	= 'Extensible logging platform'
	spec.source		= { :git => 'https://github.com/grangej/Logger.git', :tag => 'v5.0.5' }
	spec.xcconfig = { 'SWIFT_VERSION' => '5.0' }
	spec.module_name	= 'Logger'
	spec.swift_versions = ['5.0']
	spec.ios.deployment_target	= '10.0'
	
	spec.source_files	= 'Logger/**/*.swift'
	
	spec.frameworks = 'UIKit'
end