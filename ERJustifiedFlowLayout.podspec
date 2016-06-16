Pod::Spec.new do |s|
  s.name             = "ERJustifiedFlowLayout"
  s.version          = "1.1"
  s.summary          = "A subclass of UICollectionViewFlowLayout for iOS."
  s.description      = <<-DESC
                        Supports horizontal cell justification (left, full, right) and absolute inter-cell spacing."
                       DESC
  s.homepage         = "https://github.com/eroth"
  s.license          = 'MIT'
  s.license      = {
	:type => 'MIT',
	:file => 'LICENSE'
  }
  s.author           = { "Evan Roth" => "evanroth@me.com" }
  s.source           = { :git => "https://github.com/eroth/ERJustifiedFlowLayout.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.frameworks = 'UIKit'
end
