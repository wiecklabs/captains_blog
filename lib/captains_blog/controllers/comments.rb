class CaptainsBlog::Comments
  
  attr_accessor :request, :response, :logger, :blog

  def create(slug, comment)
    post = Article.first(:slug => slug)
    body = comment.chomp.gsub(/\n/, "<br>")

    if body.blank?
      response.redirect! "#{CaptainsBlog::Helpers.blog_root(@blog)}/#{post.path}",
        :message => 'Please <a href="#comment-form">provide a comment</a> before submitting.'
    end

    comment = Comment.create(:post => post, :user_id => request.session.user.id, :text => body)

    response.redirect! "#{CaptainsBlog::Helpers.blog_root(@blog)}/#{post.path}",
      :message => 'Your comment has been submitted, and will be posted after review.'
  end

end