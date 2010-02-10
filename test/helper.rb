require "rubygems"
require "pathname"
require "test/unit"
require Pathname(__FILE__).dirname.parent + "lib/captains_blog"
require "harbor/test/test"

DataMapper.setup :default, "sqlite3::memory:"
DataMapper.auto_migrate!

DataObjects::Sqlite3.logger = DataObjects::Logger.new(Pathname(__FILE__).dirname + "../log/test_db.log", :debug)


Role.create(:name => "Guest", :description => "Guest role")
admin_role = Role.create!(:name => "Admin", :description => "Site administrators")

# We'll give our new user full permissions...
PermissionSet::permissions.each do |name, permissions|
  role = RolePermissionSet.new(:role => admin_role, :name => name)
  role.add *permissions
  role.save
  role.propagate_permissions!
end


class Test::Unit::TestCase
  def create_blog
    Blog.create!(:slug => 'my_blog', :title => 'My Blog')
  end

  def create_author(blog, user)
    Author.create!(:blog => blog, :user => user)
  end

  def create_admin
    user = User.create!(:email => 'sample@example.com', :password => 'example', :password_confirmation => 'example')

    user.roles << Role.first(:name => "Admin")
    user.save!

    # TODO there should be another way of doing this...
    RolePermissionSet.all.each { |role| role.propagate_permissions! }

    user
  end

  def create_user(email = 'sample@example.com')
    User.create!(:email => email, :password => 'example', :password_confirmation => 'example')
  end
end