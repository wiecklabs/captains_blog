class CaptainsBlog::BlogAdmin::Posts

  include CaptainsBlog::Authorization
  
  attr_accessor :request, :response, :logger, :blog

  deny_unless_author
  def index
    response.render "blog_admin/posts/index", :posts => Post.all, :blog => @blog
  end

  deny_unless_author
  def show(post_id)
    response.render "blog_admin/posts/show", :post => Post.get(post_id), :blog => @blog
  end

  deny_unless_author
  def new
    response.render "blog_admin/posts/new", :post => Post.new, :blog => @blog, :authors => @blog.authors
  end

  deny_unless_author
  def edit(post_id)
    response.render "blog_admin/posts/edit", :post => Post.get(post_id), :blog => @blog, :authors => @blog.authors
  end

  deny_unless_author
  def create(post_params, categories, tags)
    post = Post.new
    post.blog = @blog
    post_params["published_at"] = UI::DateTimeTextBox.build(post_params["published_at"])
    post.attributes = post_params

    context = post.published? ? :publish : :draft

    if post.valid?(context)
      post.categories = Category.all(:id => categories)
      post.save
      tags.each { |tag| post.tag!(tag) }

      response.redirect "#{CaptainsBlog.root}/#{@blog.slug}/admin/posts/#{post.id}", :message => "Saved Post #{post.to_s}"
    else
      response.render "blog_admin/posts/new", :post => post, :blog => @blog, :authors => @blog.authors
    end
  end

  deny_unless_author
  def update(post_id, post_params, categories, tags)
    post = Post.get(post_id)
    post_params["published_at"] = UI::DateTimeTextBox.build(post_params["published_at"])
    post.attributes = post_params
    
    context = post.published? ? :publish : :draft

    if post.valid?(context)
      Tagging.all(:blog_id => post.blog_id, :post_id => post.id).destroy!
      tags.each { |tag| post.tag!(tag) }

      post.categories.clear
      post.categories = Category.all(:id => categories)
      
      post.save

      response.redirect "#{CaptainsBlog.root}/#{@blog.slug}/admin/posts/#{post.id}", :message => "Saved Post #{post.to_s}"
    else
      response.render "blog_admin/posts/edit", :post => post, :blog => @blog, :authors => @blog.authors
    end
  end

  deny_unless_author
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

  deny_unless_author
  def publish(post_id, post_params, categories, tags)
    post = if post_id
      Post.get(post_id.to_i)
    else
      Post.new(:blog => @blog)
    end

    if post_params.key? "published_at"
      post_params["published_at"] = UI::DateTimeTextBox.build(post_params["published_at"])
    end
    post.attributes = post_params

    if post.publish!
      post.categories.clear
      post.categories = Category.all(:id => categories)
      post.save!

      Tagging.all(:blog_id => post.blog_id, :post_id => post.id).destroy!
      tags.each { |tag| post.tag!(tag) }

      response.redirect "#{CaptainsBlog.root}/#{@blog.slug}/admin/posts/#{post.id}", :message => "Published Post \"#{post.to_s}\""
    else
      response.render "blog_admin/posts/edit", :post => post, :blog => @blog, :authors => @blog.authors
    end
  end

end
