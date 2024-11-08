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

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org'
    spec.metadata['rubygems_mfa_required'] = 'true'
  else
    raise 'RubyGems 2.0 or newer is required to set allowed_push_host.'
  end

  spec.files         = Dir['lib/**/*.rb', 'LICENSE.txt']
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 3.2'

  spec.add_dependency 'activerecord', '>= 7.0'
  spec.add_dependency 'activesupport', '>= 7.0'

  spec.add_development_dependency 'appraisal'
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'database_cleaner', '>= 1.2'
  spec.add_development_dependency 'rake', '>= 12.0'
  spec.add_development_dependency 'rspec', '~> 3.11.0'
  spec.add_development_dependency 'rspec_junit_formatter'
  spec.add_development_dependency 'salsify_rubocop', '~> 1.27.1'
  spec.add_development_dependency 'simplecov', '~> 0.15.1'
  # We can increase the sqlite3 major after we stop supporting Rails 7.0
  spec.add_development_dependency 'sqlite3', '~> 1.7.3'
end
