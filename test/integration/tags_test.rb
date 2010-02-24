require "pathname"
require Pathname(__FILE__).dirname + ".." + "helper"

module Integration
  class TagsTest < Test::Unit::TestCase
    include Harbor::Test

    def setup
      @blog = create_blog
      @user = create_admin
      @author = create_author(@blog, @user)

      container = Harbor::Container.new
      container.register(:tags, CaptainsBlog::BlogAdmin::Tags)
      container.register(:request, Request)
      container.register(:response, Response)
      container.register(:session, Session.new({:user_id => @user.id}))
      container.register(:blog, @blog)

      @controller = container.get(:tags)
    end

    def test_removing_tag_from_posts
      create_post(@author, @blog).tag!('ruby')
      create_post(@author, @blog).tag!('ruby')

      # Assert taggings were created
      assert 2, Tagging.all(:blog_id => @blog.id).size

      @controller.delete(Tag.first(:name => 'ruby').id)

      assert 0, Tagging.all(:blog_id => @blog.id).size
    end
  end
end