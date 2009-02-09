# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{win32_service_manager}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["James Tucker"]
  s.date = %q{2009-02-09}
  s.default_executable = %q{win32_service_manager}
  s.description = %q{A simple wrapper around Win32::Service to present a more 'God'  (http://god.rubyforge.org) like interface. Also presents all service  information as hashes rather than structs to save on wire transport and  multi-platform complexity.}
  s.email = %q{raggi@rubyforge.org}
  s.executables = ["win32_service_manager"]
  s.extra_rdoc_files = ["History.txt", "README.rdoc", "bin/win32_service_manager"]
  s.files = ["History.txt", "Manifest.txt", "README.rdoc", "Rakefile", "bin/win32_service_manager", "lib/win32_service_manager.rb", "spec/helper.rb", "spec/runner", "spec/spec_win32_service_manager.rb", "tasks/autospec.rake", "tasks/bacon.rake", "tasks/bones.rake", "tasks/gem.rake", "tasks/git.rake", "tasks/manifest.rake", "tasks/notes.rake", "tasks/post_load.rake", "tasks/rdoc.rake", "tasks/rubyforge.rake", "tasks/setup.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/raggi/win32_service_manager}
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{libraggi}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{A simple wrapper around Win32::Service to present a more 'God'  (http://god}
  s.test_files = ["spec/spec_win32_service_manager.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<bones>, [">= 0"])
      s.add_development_dependency(%q<bacon>, [">= 0"])
    else
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<bones>, [">= 0"])
      s.add_dependency(%q<bacon>, [">= 0"])
    end
  else
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<bones>, [">= 0"])
    s.add_dependency(%q<bacon>, [">= 0"])
  end
end
