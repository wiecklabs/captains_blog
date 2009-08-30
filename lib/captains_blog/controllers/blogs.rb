class CaptainsBlog::Blogs

  attr_accessor :request, :response, :logger

  def index
    blogs = Blog.all

    response.render "admin/blogs/index", :layout => "layouts/admin", :blogs => blogs
  end

  def edit(id)
    blog = Blog.get(id)

    response.render "admin/blogs/edit", :layout => "layouts/admin", :blog => blog
  end

  def update(id, blog_params)
    blog = Blog.get(id)
    blog.attributes =  blog_params

    if blog.save
      response.redirect "/admin/blogs/#{id}/edit", :message => "'#{blog.title}' was updated."
    else
      response.render "admin/blogs/edit", :layout => "layouts/admin", :blog => blog
    end
  end

end
