class CaptainsBlog::Comments
  
  attr_accessor :request, :response, :logger, :blog

  def create(slug, params)
    post = Article.first(:slug => slug)
    body = params.delete("body").to_s.chomp.gsub(/\n/, "<br>")

    params[:user_id] = request.session.user.id if request.session.user
    comment = Comment.new(params.merge(:post => post, :text => body))

    if body.blank?
      return response.render blog.page('pages/show_post'), :comment => comment, :blog => blog, :post => post,
        :error => 'Please <a href="#comment-form">provide a comment</a> before submitting.'
    end

    if comment.save
      if CaptainsBlog.approvals_required?
        response.redirect! "#{CaptainsBlog::Helpers.blog_root(@blog)}/#{post.path}",
          :message => 'Your comment has been submitted, and will be posted after review.'
      else
        response.redirect! "#{CaptainsBlog::Helpers.blog_root(@blog)}/#{post.path}"
      end
    else
      response.errors << UI::ErrorMessages::DataMapperErrors.new(comment)
      response.render blog.page('pages/show_post'), :comment => comment, :blog => blog, :post => post
    end
  end

end