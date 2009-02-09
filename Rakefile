load 'tasks/setup.rb'

ensure_in_path 'lib'
require 'win32_service_manager'

task :default => :test

PROJ.name = 'win32_service_manager'
PROJ.authors = 'James Tucker'
PROJ.email = 'raggi@rubyforge.org'
PROJ.url = 'http://github.com/raggi/win32_service_manager'
PROJ.rubyforge.name = 'libraggi'
PROJ.version = Win32ServiceManager.version

desc 'cleanup and rebuild everything'
task :full => %w(clean clobber manifest:create gem:spec gem doc)