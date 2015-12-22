# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rails_multitenant/version'

Gem::Specification.new do |spec|
  spec.name          = "rails_multitenant"
  spec.version       = RailsMultitenant::VERSION
  spec.authors       = ["Pat Breault"]
  spec.email         = ["pbreault@salsify.com"]
  spec.summary       = %q{TODO: Write a short summary, because Rubygems requires one.}
  spec.description   = %q{TODO: Write a longer description or delete this line.}
  spec.homepage      = "TODO: Put your gem's website or public repo URL here."

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.test_files    = Dir.glob('spec/**/*')
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_dependency 'activerecord', ENV.fetch('RAILS_VERSION', ['>= 3.2', '< 4.3'])
  spec.add_dependency 'activesupport', ENV.fetch('RAILS_VERSION', ['>= 3.2', '< 4.3'])

  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'database_cleaner', '>= 1.2'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 2'
  spec.add_development_dependency 'simplecov', '~> 0.7.1'
  spec.add_development_dependency 'sqlite3'
end
