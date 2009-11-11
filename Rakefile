require "rubygems"
require "pathname"
require "rake"

# Gem
require "rake/gempackagetask"

NAME = "captains_blog"
SUMMARY = "CaptainsBlog: Blog for Harbor Applications"
GEM_VERSION = "0.3.4"

spec = Gem::Specification.new do |s|
  s.name = NAME
  s.summary = s.description = SUMMARY
  s.author = "Wieck Media"
  s.homepage = "http://wiecklabs.com"
  s.email = "dev@wieck.com"
  s.version = GEM_VERSION
  s.platform = Gem::Platform::RUBY
  s.require_path = 'lib'
  s.files = %w(Rakefile) + Dir.glob("lib/**/*")
  s.executables = ['captains_blog']

  s.add_dependency 'logging'
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

desc "Install Captains Blog as a gem"
task :install => [:repackage] do
  sh %{gem install pkg/#{NAME}-#{GEM_VERSION}}
end