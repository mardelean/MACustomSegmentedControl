Pod::Spec.new do |spec|
  spec.name         = ’CustomSegmentedControl’
  spec.version      = ‘0.0.1’
  spec.license      = { :type => ‘MIT’ }
  spec.homepage     = 'https://github.com/MadalinaArdelean/MACustomSegmentedControl'
  spec.authors      = { ‘Madalina Ardelean’ => ‘ardeleanmada1@gmail.com’ }
  spec.summary      = ‘A custom segmented control with rectangular sgments.’
  spec.source       = { :git => 'https://github.com/MadalinaArdelean/MACustomSegmentedControl.git', :tag => 'v0.0.1’ }
  spec.source_files = 'SegmentedControl/Classes/GUI/CustomSegmentedControl/Views/MACustomSegmentedControlView.{h,m}’
  spec.framework    = ‘UIKit’
  spec.requires_arc = true
end