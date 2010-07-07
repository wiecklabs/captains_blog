class CaptainsBlog::Posts

  include PortAuthority::Authorization
  
  attr_accessor :request, :response, :logger, :blog

  protect "BlogPosts", "list"
  def index
    posts = blog.published_posts
    response.render blog.themed_post_path("posts/index"), :blog => blog, :posts => posts
  end

  protect "BlogPosts", "list"
  def tagged(tag_name)
    posts = @blog.published_posts.all('taggings.tag_id' => Tag.first(:name => tag_name).id)
    response.render blog.themed_post_path("posts/index"), :blog => blog, :posts => posts
  end

  protect "BlogPosts", "list"
  def under(category_title)
    posts = @blog.published_posts.all('categories.category_id' => Category.first(:title => category_title).id)
    response.render blog.themed_post_path("posts/index"), :blog => blog, :posts => posts
  end

  protect "BlogPosts", "show"
  def show(slug_or_id)
    post = if slug_or_id.is_a?(Integer)
      blog.posts.get(slug_or_id)
    else
      blog.posts.first(:slug => slug_or_id.downcase)
    end
    
    response.abort!(404) unless post
    
    comments = post.approved_comments

    response.render blog.themed_post_path('posts/show_post'), :blog => blog, :post => post, :comments => comments
  end

  protect "BlogPosts", "comment"
  def leave_comment(post_slug, comment_params)
    post = blog.posts.first(:slug => post_slug)
    comment = Comment.new(comment_params.update(:post => post))
    if comment.save
      response.redirect request.referrer, :message => "Thanks, you're comment will appear shortly"
    else
      raise "no"
    end

  end

end
