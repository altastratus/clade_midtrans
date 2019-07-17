#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'clade_midtrans'
  s.version          = '0.0.1'
  s.summary          = 'A new Flutter plugin.'
  s.description      = <<-DESC
A new Flutter plugin.
                       DESC
  s.homepage         = 'http://clade.ventures'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Clade Ventures' => 'edi@clade.ventures' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'

  s.dependency 'MidtransCoreKit'
  s.dependency 'MidtransKit'

  #s.ios.deployment_target = '10.0'
  #s.swift_version = '4.2'

  s.preserve_paths = 'flutter_midtrans_wrapper.framework'
  s.xcconfig = { 'OTHER_LDFLAGS' => '-framework flutter_midtrans_wrapper' }
  s.vendored_frameworks = 'flutter_midtrans_wrapper.framework'

  s.static_framework = true
end

