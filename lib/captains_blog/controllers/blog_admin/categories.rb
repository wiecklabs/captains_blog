class CaptainsBlog::BlogAdmin::Categories
  include PortAuthority::Authorization

  attr_accessor :request, :response, :logger, :blog

  deny_unless_author
  def index
    response.render "blog_admin/categories/index", :categories => Category.roots, :blog => @blog
  end

  deny_unless_author
  def show(category_id)
    response.render "blog_admin/categories/show", :category => Category.get(category_id), :blog => @blog
  end

  deny_unless_author
  def new
    response.render "blog_admin/categories/new", :category => Category.new, :blog => @blog
  end

  deny_unless_author
  def edit(category_id)
    response.render "blog_admin/categories/edit", :category => Category.get(category_id), :blog => @blog
  end

  deny_unless_author
  def create(category_params)
    category = Category.new
    category.attributes = category_params

    if category.save
      response.redirect "#{CaptainsBlog.root}/#{@blog.slug}/admin/categories/#{category.id}", :message => "Saved Category #{category.to_s}"
    else
      response.render "blog_admin/categories/new", :category => category, :blog => @blog
    end
  end

  deny_unless_author
  def update(category_id, category_params)
    category = Category.get(category_id)
    category.attributes = category_params

    if category.save
      response.redirect "#{CaptainsBlog.root}/#{@blog.slug}/admin/categories/#{category.id}", :message => "Saved Category #{category.to_s}"
    else
      response.render "blog_admin/categories/show", :category => category, :blog => @blog
    end
  end

  deny_unless_author
  def delete(category_id)
    category = Category.get(category_id)

    if request.xhr?
      return response.puts(category.destroy)
    else
      if category.destroy
        response.redirect "#{CaptainsBlog.root}/#{@blog.slug}/admin/categories", :message => "Deleted Category #{category.to_s}"
      else
        response.render "blog_admin/categories/show", :category => category, :blog => @blog
      end
    end
  end

end