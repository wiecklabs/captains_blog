class CaptainsBlog::BlogAdmin::Comments
  include PortAuthority::Authorization

  attr_accessor :request, :response, :logger, :blog

  protect
  def index(post_id)
    post = Post.first(:id => post_id)
    response.redirect! "#{CaptainsBlog::Helpers.blog_root(@blog)}/admin/",
      :message => "That post does not exist." if post.nil?
    
    comments = post.comments.all(:order => [:created_at.desc])

    response.render "blog_admin/posts/comments", :post => post, :comments => comments, :blog => @blog
  end

  protect
  def approve(comment_id)
    comment = Comment.first(:id => comment_id)
    
    response.redirect! "#{CaptainsBlog.root}/#{@blog.slug}/admin/posts/",
      :message => "That comment does not exist." if comment.nil?

    comment.approved = true

    if comment.save
      response.redirect! "#{CaptainsBlog.root}/#{@blog.slug}/admin/posts/#{comment.post.id}/comments",
        :message => "Comment approved!"
    else
      response.redirect! "#{CaptainsBlog.root}/#{@blog.slug}/admin/posts/#{comment.post.id}/comments",
        :message => "Something went wrong. Comment could not be approved."
    end
  end

  protect
  def disapprove(comment_id)
    comment = Comment.first(:id => comment_id)
    
    response.redirect! "#{CaptainsBlog.root}/#{@blog.slug}/admin/posts/",
      :message => "That comment does not exist." if comment.nil?

    comment.approved = false

    if comment.save
      response.redirect! "#{CaptainsBlog.root}/#{@blog.slug}/admin/posts/#{comment.post.id}/comments",
        :message => "Comment disapproved!"
    else
      response.redirect! "#{CaptainsBlog.root}/#{@blog.slug}/admin/posts/#{comment.post.id}/comments",
        :message => "Something went wrong. Comment could not be disapproved."
    end
  end
end
