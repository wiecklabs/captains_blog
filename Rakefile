require "rubygems"
require "pathname"
require "rake"

# Gem
require "rake/gempackagetask"

NAME = "captains_blog"
SUMMARY = "A "
GEM_VERSION = "0.1"

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

desc "Publish Captains Blog gem"
task :publish do
  STDOUT.print "Publishing gem... "
  STDOUT.flush
  `git tag -a #{GEM_VERSION} -m "v. #{GEM_VERSION}" &> /dev/null`
  `git push --tags &> /dev/null`

  commands = [
    "if [ ! -d '#{NAME}' ]; then git clone git://github.com/wiecklabs/captains_blog.git; fi",
    "cd #{NAME}",
    "git pull &> /dev/null",
    "rake repackage &> /dev/null",
    "cp pkg/* ../site/gems",
    "cd ../site",
    "gem generate_index"
  ]

  `ssh gems@able.wieck.com "#{commands.join(" && ")}"`
  STDOUT.puts "done"
end
