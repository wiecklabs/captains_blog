require "pathname"
require Pathname(__FILE__).dirname + ".." + "helper"
require 'date'

module Unit
  class PostTest < Test::Unit::TestCase
    def setup
      @blog = create_blog
      @author = create_author(@blog, create_user)
    end

    def test_new_post_is_not_published
      post = create_post

      assert ! post.published
    end

    def test_publishing
      post = create_post

      assert post.publish!
      assert post.published
    end

    def test_requires_title_and_date_for_publishing
      post = create_post(nil, nil)
      assert ! post.publish!

      post.attributes = {:title => 'title', :published_at => Time.now}
      assert post.publish!
    end

    def test_path
      date = Date.today - 1
      post = create_post(date, 'my-title')
      post.publish!

      assert_equal "#{date.strftime("%Y/%m/%d")}/my-title", post.path
    end

    def test_path_returns_id_if_draft
      date = Date.today - 1
      post = create_post(date, 'my-title')

      assert_equal "posts/#{post.id}", post.path
    end

    def test_draft_does_not_accept_comments
      post = create_post
      assert ! post.accepting_comments?

      post.publish!
      assert post.accepting_comments?
    end

    def test_tagging
      post = create_post

      post.tag!('ruby')
      post.tag!('testing')

      assert_equal 2, post.tags.size
    end

    def test_duplicated_tags
      post = create_post

      post.tag!('ruby')
      post.tag!('ruby')

      assert_equal 1, post.tags.size
    end

    protected

    def create_post(published_at = Time.now, title = 'title')
      Post.create!(:author => @author, :blog => @blog, :title => title, :published_at => published_at, :content => 'ssss')
    end
  end
end
