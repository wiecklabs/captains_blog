class CaptainsBlog::BlogAdmin::Comments
  include CaptainsBlog::Authorization
  include Harbor::Events
  attr_accessor :request, :response, :logger, :blog

  deny_unless_author
  def index(post_id)
    post = Post.first(:id => post_id)
    response.redirect! "#{CaptainsBlog::Helpers.blog_root(@blog)}/admin/",
      :message => "That post does not exist." if post.nil?
    
    comments = post.comments.all(:order => [:created_at.desc])

    response.render "blog_admin/posts/comments", :post => post, :comments => comments, :blog => @blog
  end

  deny_unless_author
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

  deny_unless_author
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
  
  protect "Comments", "destroy"
  def delete(comment_id)
    comment = Comment.first(:id => comment_id)
    
    case request.request_method
    when "GET"
      context = { :comment => comment, :blog => @blog }
      context[:layout] = nil if request.xhr?
      response.render "blog_admin/comments/delete", context
    when "DELETE"
      comment.destroy
      raise_event(:comment_deleted, request, response, comment)
      response.message("success", "Comment was deleted")
      response.redirect! "#{CaptainsBlog.root}/#{@blog.slug}/admin/posts/#{comment.post.id}/comments"
    end
  end
end
