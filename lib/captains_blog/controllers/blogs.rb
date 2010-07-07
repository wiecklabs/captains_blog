class CaptainsBlog::Blogs
  include PortAuthority::Authorization

  attr_accessor :request, :response, :logger

  protect "Blogs", "index"
  def index
    blogs = Blog.all

    response.render "admin/blogs/index", :blogs => blogs
  end

  protect "Blogs", "create"
  def new
    blog = Blog.new
    response.render "admin/blogs/new", :blog => blog
  end

  protect "Blogs", "update"
  def edit(id)
    blog = Blog.get(id)

    response.render "admin/blogs/edit", :blog => blog
  end

  protect "Blogs", "create"
  def create(blog_params)
    blog = Blog.new(blog_params)

    if blog.save
      # current user will always be added as an author to blog
      blog.authors.new(:user => request.session.user).save!

      response.redirect "/admin/blogs", :message => "'#{blog.title}' was created."
    else
      response.render "admin/blogs/new", :blog => blog
    end
  end

  protect "Blogs", "update"
  def update(id, blog_params)
    blog = Blog.get(id)
    blog.attributes =  blog_params

    if blog.save
      response.redirect "/admin/blogs/#{id}/edit", :message => "'#{blog.title}' was updated."
    else
      response.render "admin/blogs/edit", :blog => blog
    end
  end

end
