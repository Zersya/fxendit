#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint fxendit.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'fxendit'
  s.version          = '0.0.1'
  s.summary          = 'Xendit plugin'
  s.description      = <<-DESC
  Using Xendit SDK.
                       DESC
  s.homepage         = 'https://github.com/salkuadrat/fxendit'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Indieapps' => 'zein@indieapps.id' }
  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'
  s.platform         = :ios, '9.0'
  s.dependency 'Flutter'
  s.dependency 'Xendit', '>= 3.4'

  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
  s.public_header_files = 'Classes/**/*.h'
end
