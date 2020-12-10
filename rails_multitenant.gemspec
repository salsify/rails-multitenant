# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rails_multitenant/version'

Gem::Specification.new do |spec|
  spec.name          = 'rails_multitenant'
  spec.version       = RailsMultitenant::VERSION
  spec.authors       = ['Pat Breault']
  spec.email         = ['pbreault@salsify.com']
  spec.summary       = 'Automatically configures multiple tenants in a Rails environment'
  spec.description   = 'Handles multiple tenants in a Rails environment'
  spec.homepage      = 'https://github.com/salsify/rails-multitenant'
  spec.license       = 'MIT'

  spec.files         = Dir['lib/**/*.rb', 'LICENSE.txt']
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.4.0'

  spec.add_dependency 'activerecord', '>= 4.2', '< 6.2'
  spec.add_dependency 'activesupport', '>= 4.2', '< 6.2'

  spec.add_development_dependency 'appraisal'
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'database_cleaner', '>= 1.2'
  spec.add_development_dependency 'rake', '>= 12.0'
  spec.add_development_dependency 'rspec', '~> 3.8.0'
  spec.add_development_dependency 'rspec_junit_formatter'
  spec.add_development_dependency 'salsify_rubocop', '0.63.0'
  spec.add_development_dependency 'simplecov', '~> 0.15.1'
  spec.add_development_dependency 'sqlite3', '~> 1.4.0'
end
