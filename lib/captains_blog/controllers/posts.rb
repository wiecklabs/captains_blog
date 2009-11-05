class CaptainsBlog::Posts
  
  attr_accessor :request, :response, :logger, :blog

  def index
    response.render blog.themed_post_path("posts/index"), :blog => blog, :posts => blog.posts
  end

  def show(slug)
    post = blog.posts.first(:slug => slug.downcase)
    response.abort!(404) unless post
    
    comments = Comment.require_approvals? ? post.comments.all(:approved => true) : post.comments

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
