require "rubygems"
require "pathname"
require "test/unit"
require Pathname(__FILE__).dirname.parent + "lib/captains_blog"
require "harbor/test/test"

DataMapper.setup :default, "sqlite3::memory:"
DataMapper.auto_migrate!

#DataObjects::Sqlite3.logger = DataObjects::Logger.new(Pathname(__FILE__).dirname + "../log/test_db.log", :debug)