class CaptainsBlog::Articles
  
  attr_accessor :request, :response, :logger, :blog

  def index
    response.render blog.themed_article_path("articles/index"), :blog => blog, :articles => blog.articles
  end

  def show(slug)
    post = blog.articles.first(:slug => slug.downcase)
    response.abort!(404) unless post

    response.render blog.themed_article_path('articles/show_post'), :blog => blog, :article => post
  end

  def leave_comment(post_slug, comment_params)
    post = blog.posts.first(:slug => post_slug)
    comment = Comment.new(comment_params.update(:article => post))
    if comment.save
      response.redirect request.referrer, :message => "Thanks, you're comment will appear shortly"
    else
      raise "no"
    end

  end

end
