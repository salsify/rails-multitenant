# -*- encoding: utf-8 -*-
# stub: rest-client 1.6.7 ruby lib

Gem::Specification.new do |s|
  s.name = "rest-client"
  s.version = "1.6.7"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Adam Wiggins", "Julien Kirch"]
  s.date = "2011-08-24"
  s.description = "A simple HTTP and REST client for Ruby, inspired by the Sinatra microframework style of specifying actions: get, put, post, delete."
  s.email = "rest.client@librelist.com"
  s.executables = ["restclient"]
  s.extra_rdoc_files = ["README.rdoc", "history.md"]
  s.files = ["README.rdoc", "bin/restclient", "history.md"]
  s.homepage = "http://github.com/archiloque/rest-client"
  s.rubygems_version = "2.4.5.1"
  s.summary = "Simple HTTP and REST client for Ruby, inspired by microframework syntax for specifying actions."

  s.installed_by_version = "2.4.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<mime-types>, [">= 1.16"])
      s.add_development_dependency(%q<webmock>, [">= 0.9.1"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
    else
      s.add_dependency(%q<mime-types>, [">= 1.16"])
      s.add_dependency(%q<webmock>, [">= 0.9.1"])
      s.add_dependency(%q<rspec>, [">= 0"])
    end
  else
    s.add_dependency(%q<mime-types>, [">= 1.16"])
    s.add_dependency(%q<webmock>, [">= 0.9.1"])
    s.add_dependency(%q<rspec>, [">= 0"])
  end
end
