class CaptainsBlog::Comments
  
  attr_accessor :request, :response, :logger, :blog

  def create(slug, params)
    article = Article.first(:slug => slug)
    body = params.delete("body").to_s.chomp.gsub(/\n/, "<br>")

    params[:user_id] = request.session.user.id if request.session.user
    comment = Comment.new(params.merge(:article => article, :text => body))

    if body.blank?
      return response.render blog.themed_article_path('articles/show_post'), :comment => comment, :blog => blog, :article => article,
        :error => 'Please <a href="#comment-form">provide a comment</a> before submitting.'
    end

    if comment.save
      if CaptainsBlog.approvals_required?
        response.redirect! "#{CaptainsBlog::Helpers.blog_root(@blog)}/#{article.path}",
          :message => 'Your comment has been submitted, and will be posted after review.'
      else
        response.redirect! "#{CaptainsBlog::Helpers.blog_root(@blog)}/#{article.path}"
      end
    else
      response.errors << UI::ErrorMessages::DataMapperErrors.new(comment)
      response.render blog.themed_article_path('articles/show_post'), :comment => comment, :blog => blog, :article => article
    end
  end

end
