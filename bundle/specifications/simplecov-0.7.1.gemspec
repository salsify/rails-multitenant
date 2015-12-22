# -*- encoding: utf-8 -*-
# stub: simplecov 0.7.1 ruby lib

Gem::Specification.new do |s|
  s.name = "simplecov"
  s.version = "0.7.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Christoph Olszowka"]
  s.date = "2012-10-12"
  s.description = "Code coverage for Ruby 1.9 with a powerful configuration library and automatic merging of coverage across test suites"
  s.email = ["christoph at olszowka de"]
  s.homepage = "http://github.com/colszowka/simplecov"
  s.rubygems_version = "2.4.5.1"
  s.summary = "Code coverage for Ruby 1.9 with a powerful configuration library and automatic merging of coverage across test suites"

  s.installed_by_version = "2.4.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<multi_json>, ["~> 1.0"])
      s.add_runtime_dependency(%q<simplecov-html>, ["~> 0.7.1"])
      s.add_development_dependency(%q<aruba>, [">= 0"])
      s.add_development_dependency(%q<capybara>, [">= 0"])
      s.add_development_dependency(%q<appraisal>, [">= 0"])
      s.add_development_dependency(%q<cucumber>, [">= 1.1.4"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<shoulda>, [">= 0"])
    else
      s.add_dependency(%q<multi_json>, ["~> 1.0"])
      s.add_dependency(%q<simplecov-html>, ["~> 0.7.1"])
      s.add_dependency(%q<aruba>, [">= 0"])
      s.add_dependency(%q<capybara>, [">= 0"])
      s.add_dependency(%q<appraisal>, [">= 0"])
      s.add_dependency(%q<cucumber>, [">= 1.1.4"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<shoulda>, [">= 0"])
    end
  else
    s.add_dependency(%q<multi_json>, ["~> 1.0"])
    s.add_dependency(%q<simplecov-html>, ["~> 0.7.1"])
    s.add_dependency(%q<aruba>, [">= 0"])
    s.add_dependency(%q<capybara>, [">= 0"])
    s.add_dependency(%q<appraisal>, [">= 0"])
    s.add_dependency(%q<cucumber>, [">= 1.1.4"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<shoulda>, [">= 0"])
  end
end
