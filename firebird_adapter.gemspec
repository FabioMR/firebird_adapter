lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = 'firebird_adapter'
  spec.version       = '6.0.0'
  spec.authors       = ['Fábio Rodrigues']
  spec.email         = ['fabio.info@gmail.com']
  spec.summary       = 'ActiveRecord Firebird Adapter for Rails 6.'
  spec.homepage      = 'https://github.com/FabioMR/firebird_adapter'
  spec.license       = 'MIT'

  spec.files = Dir['lib/**/*']
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.required_ruby_version = '~> 2.7'

  spec.add_dependency 'rails', '~> 6.0'
  spec.add_dependency 'fb', '~> 0.9.0'

  spec.add_development_dependency 'bundler', '~> 2.1.4'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.7'
  spec.add_development_dependency 'database_cleaner', '~> 1.6'
  spec.add_development_dependency 'pry-meta', '~> 0.0.10'
end
