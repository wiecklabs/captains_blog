require "rubygems"
require "pathname"
require "test/unit"
require Pathname(__FILE__).dirname.parent + "lib/captains_blog"
require "harbor/test/test"

DataMapper.setup :default, "sqlite3::memory:"
DataMapper.auto_migrate!

DataObjects::Sqlite3.logger = DataObjects::Logger.new(Pathname(__FILE__).dirname + "../log/test_db.log", :debug)

class Test::Unit::TestCase
  def create_blog
    Blog.create!(:slug => 'my_blog', :title => 'My Blog')
  end

  def create_user
    User.create!(:email => 'sample@example.com', :password => 'example', :password_confirmation => 'example')
  end
end