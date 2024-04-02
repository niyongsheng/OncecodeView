Pod::Spec.new do |s|
  s.name                = "OncecodeView"
  s.version             = "0.0.1"
  s.platform            = :ios, "9.0"
  s.swift_version       = "4.0", "4.2", "5.0"
  s.summary             = "oncecode input view."
  s.homepage            = "https://github.com/niyongsheng/OncecodeView"
  s.license             = { :type => "MIT", :file => "LICENSE" }
  s.author              = { 'NiYongsheng' => 'niyongsheng@outlook.com' }
  s.source              = { :git => "https://github.com/niyongsheng/OncecodeView.git", :tag => "#{s.version}" }
  s.source_files        = "Sources/**/*.{h,m,swift}"
end
