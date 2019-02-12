Pod::Spec.new do |s|
  s.name = 'SwiftExtensions'
  s.version = '1.0.0'
  s.summary = 'A handy collection of native Swift extensions'
  s.description = <<-DESC
  SwiftExtensions is a collection of native Swift extensions.
                   DESC

  s.homepage = 'https://github.com/macistador/SwiftExtensions'
  s.license = { type: 'MIT', file: 'LICENSE' }
  s.authors = { 'Michel-André Chirita' => 'macistador@hotmail.com' }
  s.social_media_url = 'http://twitter.com/macistador'
  s.screenshot = 'https://raw.githubusercontent.com/macistador/SwiftExtensions/master/Assets/logo.png'
  s.documentation_url = 'http://github.com/macistador/SwiftExtensions'

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.10'
  s.tvos.deployment_target = '9.0'
  s.watchos.deployment_target = '2.0'

  s.swift_version = '4.2'
  s.requires_arc = true
  s.source = { git: 'https://github.com/macistador/SwiftExtensions.git', tag: s.version.to_s }
  s.source_files = '*.swift'

end
