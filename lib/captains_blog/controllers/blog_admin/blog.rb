class CaptainsBlog::BlogAdmin::Blog
  
  attr_accessor :request, :response, :logger

  def dashboard
    response.render "blog_admin/blog/dashboard", :layout => "layouts/blog_admin"
  end

end