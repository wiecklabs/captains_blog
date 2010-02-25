require "pathname"
require Pathname(__FILE__).dirname + ".." + "helper"

module Integration
  class PostsTest < Test::Unit::TestCase
    include Harbor::Test

    def setup
      @blog = create_blog
      @user = create_admin
      @author = create_author(@blog, @user)

      container = Harbor::Container.new
      container.register(:posts, CaptainsBlog::BlogAdmin::Posts)
      container.register(:request, Request)
      container.register(:response, Response)
      container.register(:session, Session.new({:user_id => @user.id}))
      container.register(:blog, @blog)

      @controller = container.get(:posts)
    end

    def test_do_not_publish_invalid_post
      @controller.publish(nil, post_params(nil), [], [])

      assert @blog.reload.published_posts.size == 0
    end

    def test_publish_new_post
      @controller.publish(nil, post_params, [], [])

      assert @blog.reload.published_posts.size == 1
    end

    def test_publish_draft
      post = create_post(@author, @blog)
      
      @controller.publish(post.id, post_params, [], [])

      assert @blog.reload.published_posts.size == 1
    end

    protected

    def post_params(published_at = [2010, 02, 10, 0, 0, 0, -3])
      {'author_id' => @author.id, 'title' => 'Harbor rocks!', 'content' => 'Check it out :-)', 'published_at' => published_at}
    end
  end
end
