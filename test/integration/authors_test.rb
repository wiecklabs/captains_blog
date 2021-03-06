require "pathname"
require Pathname(__FILE__).dirname + ".." + "helper"

module Integration

  class AuthorsTest < Test::Unit::TestCase

    include Harbor::Test

    def setup
      @blog = create_blog
      @user = create_admin

      container = Harbor::Container.new
      container.register(:authors, CaptainsBlog::BlogAdmin::Authors)
      container.register(:request, Request)
      container.register(:response, Response)
      container.register(:session, Session.new({:user_id => @user.id}))
      container.register(:blog, @blog)

      @controller = container.get(:authors)
    end

    def test_add
      @controller.add({'byline' => 'John'})

      assert_equal 1, @blog.reload.authors.size
    end

    def test_redirects_after_creation
      @controller.add({'byline' => 'John'})

      assert_redirect @controller.response
    end

    def test_delete
      author = @blog.authors.new(:user_id => @user.id)
      author.save!

      @controller.delete(author.id)

      assert_equal 0, @blog.reload.authors.size
    end

    def test_redirects_after_deletion
      author = @blog.authors.new(:user_id => @user.id)
      author.save!

      @controller.delete(author.id)

      assert_redirect @controller.response
    end
  end
end