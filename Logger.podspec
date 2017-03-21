Pod::Spec.new do |spec|
spec.name         = 'Logger'
spec.version      = '2.1'
spec.license      = { :type => 'BSD' }
spec.homepage     = 'https://bsingh@stash.lifelock.com/scm/ios/logger.git'
spec.authors      = { 'Bikramjit Singh' => 'bikramjit.singh@lifelock.com' }
spec.summary      = 'Logger class.'
spec.source       = { :git => 'ssh://git@stash.lifelock.com:7999/ios/logger.git', :branch => 'dev_cocoapods', :tag => 'v2.1' }
spec.source_files = 'Logger/*.swift'
end
