#!/usr/bin/env ruby

ENV["ENVIRONMENT"] ||= "development"

begin
  # Try to require the preresolved locked set of gems.
  require File.expand_path('../.bundle/environment', __FILE__)
rescue LoadError
  # Fall back on doing an unlocked resolve at runtime.
  require "rubygems"
  require "bundler"
  Bundler.setup
end

require "lib/captains_blog"

# View::cache_templates!

services = Harbor::Container.new

services.register("mailer", Harbor::Mailer)
services.register("mail_server", Harbor::MailServers::Sendmail)

logger = Logging.logger((Pathname(__FILE__).dirname + "log/app.log").to_s)
logger.level = ENV["LOG_LEVEL"] || :debug
services.register("logger", logger)

DataMapper.setup :default, "sqlite3://#{Pathname(__FILE__).dirname.expand_path + "captains_blog.db"}"
DataObjects::Sqlite3.logger = DataObjects::Logger.new(Pathname(__FILE__).dirname + "log/db.log", :debug)

PortAuthority::public_path = CaptainsBlog.public_path
UI::public_path = CaptainsBlog.public_path
CaptainsBlog.root = "/blogs"
CaptainsBlog.blog_repository = Pathname(__FILE__).dirname.expand_path + 'blogs'
CaptainsBlog.require_approvals
UI::AccountNavigation.register("Site Admin", "/admin")

if $0 == __FILE__
  require "harbor/console"
  Harbor::Console.start
elsif $0['rake']
  # Require rake tasks here
  # require "some/rake/tasks"
else
  if ENV['ENVIRONMENT'] == 'development'
   require "harbor/contrib/debug"
   DataObjects::Sqlite3.logger = Logging::Logger.root
   use Harbor::Contrib::Debug
  end

  run Harbor::Cascade.new(
    ENV['ENVIRONMENT'],
    services,
    CaptainsBlog::Setup,
    CaptainsBlog::AllBlogThemes,
    CaptainsBlog,
    PortAuthority
  )
end
