require "pathname"
require Pathname(__FILE__).dirname + ".." + "helper"

module Unit

  class AuthorTest < Test::Unit::TestCase

    def setup
      @blog = create_blog
      @user = create_user
    end

    def test_to_string_defaults_to_user_name
      author = Author.create(:user_id => @user.id)

      assert_equal @user.name, author.to_s
    end

    def test_to_string_returns_byline
      author = Author.create(:user_id => @user.id, :byline => 'Little Richard')

      assert_equal 'Little Richard', author.to_s
    end

    def test_byline_is_required_if_no_user_associated
      author = Author.create
      assert ! author.save

      author.byline = 'Jimi'
      assert author.save
    end
  end
end