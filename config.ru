#!/usr/bin/env ruby

ENV["ENVIRONMENT"] ||= "development"
require "lib/captains_blog"

# View::cache_templates!

services = Harbor::Container.new

# CaptainsBlog.services.register("mailer", Harbor::Mailer)
# CaptainsBlog.services.register("mail_server", Harbor::SendmailServer)

DataMapper.setup :default, "sqlite3://#{Pathname(__FILE__).dirname.expand_path + "captains_blog.db"}"
# DataMapper.setup :search, "ferret:///tmp/captains_blog.sock"

CaptainsBlog.root = "/"

CaptainsBlog.blog_repository = Pathname(__FILE__).dirname.expand_path + 'blogs'

if $0 == __FILE__
  require "harbor/console"
  Harbor::Console.start
elsif $0['thin']
  run Harbor::Cascade.new(
    ENV['ENVIRONMENT'],
    services,
    CaptainsBlog::AllBlogThemes,
    CaptainsBlog
  )
else $0['rake']
  # Require rake tasks here
  # require "some/rake/tasks"
end
