# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rails_multitenant/version'

Gem::Specification.new do |spec|
  spec.name          = "rails_multitenant"
  spec.version       = RailsMultitenant::VERSION
  spec.authors       = ["Pat Breault"]
  spec.email         = ["pbreault@salsify.com"]
  spec.summary       = %q{Automatically configures multiple tenants in a Rails environment}
  spec.description   = %q{Handles multiple tenants in a Rails environment}
  spec.homepage      = "https://github.com/salsify/rails-multitenant"
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.test_files    = Dir.glob('spec/**/*')
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.4.0'

  spec.add_development_dependency "bundler", "~> 1.10"

  spec.add_dependency 'activerecord', ENV.fetch('RAILS_VERSION', ['>= 4.2', '< 6.1'])
  spec.add_dependency 'activesupport', ENV.fetch('RAILS_VERSION', ['>= 4.2', '< 6.1'])

  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'database_cleaner', '>= 1.2'
  spec.add_development_dependency 'rake', '< 11.0'
  spec.add_development_dependency 'rspec', '~> 2'
  spec.add_development_dependency 'simplecov', '~> 0.15.1'
  spec.add_development_dependency 'sqlite3', '~> 1.3.0'
end
