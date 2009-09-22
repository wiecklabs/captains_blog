class CaptainsBlog::BlogAdmin::Blog
  
  attr_accessor :request, :response, :logger, :blog

  def dashboard
    response.render "blog_admin/blog/dashboard", :blog => @blog
  end

end