# -*- encoding: utf-8 -*-
# stub: rspec 2.99.0 ruby lib

Gem::Specification.new do |s|
  s.name = "rspec"
  s.version = "2.99.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Steven Baker", "David Chelimsky"]
  s.date = "2014-06-01"
  s.description = "BDD for Ruby"
  s.email = "rspec-users@rubyforge.org"
  s.extra_rdoc_files = ["README.md"]
  s.files = ["README.md"]
  s.homepage = "http://github.com/rspec"
  s.licenses = ["MIT"]
  s.rdoc_options = ["--charset=UTF-8"]
  s.rubyforge_project = "rspec"
  s.rubygems_version = "2.4.5.1"
  s.summary = "rspec-2.99.0"

  s.installed_by_version = "2.4.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rspec-core>, ["~> 2.99.0"])
      s.add_runtime_dependency(%q<rspec-expectations>, ["~> 2.99.0"])
      s.add_runtime_dependency(%q<rspec-mocks>, ["~> 2.99.0"])
    else
      s.add_dependency(%q<rspec-core>, ["~> 2.99.0"])
      s.add_dependency(%q<rspec-expectations>, ["~> 2.99.0"])
      s.add_dependency(%q<rspec-mocks>, ["~> 2.99.0"])
    end
  else
    s.add_dependency(%q<rspec-core>, ["~> 2.99.0"])
    s.add_dependency(%q<rspec-expectations>, ["~> 2.99.0"])
    s.add_dependency(%q<rspec-mocks>, ["~> 2.99.0"])
  end
end
