class CaptainsBlog::BlogAdmin::Blog
  include PortAuthority::Authorization
  
  attr_accessor :request, :response, :logger, :blog

  protect
  def dashboard
    response.render "blog_admin/blog/dashboard", :blog => @blog
  end

end