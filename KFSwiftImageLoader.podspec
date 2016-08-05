Pod::Spec.new do |s|
  s.name        = 'KFSwiftImageLoader'
  s.version     = '2.0.1'
  s.summary     = 'High-performance, lightweight, and energy-efficient pure Swift async web image loader with memory and disk caching for iOS and  Watch.'
  s.homepage    = 'https://github.com/kiavashfaisali/KFSwiftImageLoader'
  s.license     = { :type => 'MIT',
		    		:file => 'LICENSE' }
  s.authors     = { 'kiavashfaisali' => 'kiavashfaisali@outlook.com' }

  s.platform = :ios, '8.2'
  s.requires_arc = true
  s.ios.deployment_target = '8.2'
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '3.0' }
  s.source   = { :git => 'https://github.com/kiavashfaisali/KFSwiftImageLoader.git',
				 :tag => s.version.to_s }
  s.source_files = 'KFSwiftImageLoader/*.swift'
end
