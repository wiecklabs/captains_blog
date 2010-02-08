class CaptainsBlog::BlogAdmin::Posts

  include PortAuthority::Authorization
  
  attr_accessor :request, :response, :logger, :blog

  protect
  def index
    response.render "blog_admin/posts/index", :posts => Post.all, :blog => @blog
  end

  protect
  def show(post_id)
    response.render "blog_admin/posts/show", :post => Post.get(post_id), :blog => @blog
  end

  protect
  def new
    response.render "blog_admin/posts/new", :post => Post.new, :blog => @blog, :authors => @blog.authors
  end

  protect
  def edit(post_id)
    response.render "blog_admin/posts/edit", :post => Post.get(post_id), :blog => @blog, :authors => @blog.authors
  end

  protect
  def create(post_params, category_params)
    post = Post.new
    post.blog = @blog
    post_params["published_at"] = UI::DateTimeTextBox.build(post_params["published_at"])
    post.attributes = post_params
    post.categories = Category.all(:id => category_params)

    if post.save
      response.redirect "#{CaptainsBlog.root}/#{@blog.slug}/admin/posts/#{post.id}", :message => "Saved Post #{post.to_s}"
    else
      response.render "blog_admin/posts/new", :post => post, :blog => @blog, :authors => @blog.authors
    end
  end

  protect
  def update(post_id, post_params, category_params)
    post = Post.get(post_id)
    post_params["published_at"] = UI::DateTimeTextBox.build(post_params["published_at"])
    post.attributes = post_params
    post.categories.clear
    post.save

    post.categories = Category.all(:id => category_params)

    if post.save
      response.redirect "#{CaptainsBlog.root}/#{@blog.slug}/admin/posts/#{post.id}", :message => "Saved Post #{post.to_s}"
    else
      response.render "blog_admin/posts/edit", :post => post, :blog => @blog, :authors => @blog.authors
    end
  end

  protect
  def delete(post_id)
    post = Post.get(post_id)

    if request.xhr?
      return response.puts(post.destroy)
    else
      if post.destroy
        response.redirect "#{CaptainsBlog.root}/#{@blog.slug}/admin/posts", :message => "Deleted Post #{post.to_s}"
      else
        response.render "blog_admin/posts/show", :post => post, :authors => @blog.authors
      end
    end
  end

end
