require "pathname"
require Pathname(__FILE__).dirname + ".." + "helper"

module Unit
  class PostTest < Test::Unit::TestCase
    def setup
      @blog = create_blog
      @author = create_author(@blog, create_user)

      @post = Post.create!(:author => @author, :blog_id => @blog.id)
    end

    def test_new_post_is_not_published
      assert ! @post.published
      assert @post.published_at.nil?
    end

    def test_publishing
      @post.publish!

      assert @post.published
      assert @post.published_at
    end
  end
end
