class CaptainsBlog::Posts
  
  attr_accessor :request, :response, :logger, :blog

  def index
    posts = blog.posts(:order => [:published_at.desc])
    response.render blog.themed_post_path("posts/index"), :blog => blog, :posts => posts
  end

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
