class CaptainsBlog::BlogAdmin::Tags

  include PortAuthority::Authorization

  attr_accessor :request, :response, :blog

  # protect "Authors", "list"
  def index
    response.render "blog_admin/tags/index", :blog => @blog
  end

end