#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'braintree_dropin'
  s.version          = '0.0.1'
  s.summary          = 'Braintree dropin full implementation for iOS and Android'
  s.description      = <<-DESC
Braintree dropin full implementation for iOS and Android
                       DESC
  s.homepage         = 'https://mysterytea.fr'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'florent@mysterytea.fr' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'BraintreeDropIn'
  s.dependency 'Braintree/Apple-Pay'

  s.ios.deployment_target = '10.0'
end

