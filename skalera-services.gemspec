# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'skalera/services/version'

Gem::Specification.new do |spec|
  spec.name          = 'skalera-services'
  spec.version       = Skalera::Services::VERSION
  spec.authors       = ['Martin Englund']
  spec.email         = ['martin@englund.nu']

  spec.summary       = 'Helper gem to handle services in consul.'
  spec.homepage      = 'http://skalera.com/'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(spec|features)/}) }
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'airbrake', '~> 4'
  spec.add_dependency 'diplomat', '~> 0'
  spec.add_dependency 'redis', '~> 3'
  spec.add_dependency 'sequel', '~> 4'
  spec.add_dependency 'pg', '~> 0'
  spec.add_dependency 'influxdb', '~> 0'

  spec.add_development_dependency 'bundler', '~> 1'
  spec.add_development_dependency 'rake', '~> 10'
  spec.add_development_dependency 'pry', '~> 0'
end
