require "pathname"
require Pathname(__FILE__).dirname + ".." + "helper"

module Integration
  class BlogTest < Test::Unit::TestCase
    def setup
      @blog = create_blog

      @mike = create_user('mike@example.com')
      @john = create_user('john@example.com')
    end

    def test_checking_if_user_is_an_author
      @blog.authors.new(:user_id => @mike.id).save!
      @blog.authors.new(:byline => 'some byline').save!

      assert @blog.author?(@mike)
      assert ! @blog.author?(@john)
    end

    def test_published_posts
      author = create_author(@blog, @user)
      post = create_post(author, @blog, Time.now).tag!('life')

      assert_equal 0, @blog.published_posts.size

      post.publish!

      assert_equal 1, @blog.published_posts.size
    end
  end
end
