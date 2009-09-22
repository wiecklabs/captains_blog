class CaptainsBlog::BlogAdmin::Categories
  
  attr_accessor :request, :response, :logger, :blog

  def index
    response.render "blog_admin/categories/index", :categories => Category.roots, :blog => @blog
  end

  def show(category_id)
    response.render "blog_admin/categories/show", :category => Category.get(category_id), :blog => @blog
  end

  def new
    response.render "blog_admin/categories/new", :category => Category.new, :blog => @blog
  end

  def edit(category_id)
    response.render "blog_admin/categories/edit", :category => Category.get(category_id), :blog => @blog
  end

  def create(category_params)
    category = Category.new
    category.attributes = category_params

    if category.save
      response.redirect "#{CaptainsBlog.root}/#{@blog.slug}/admin/categories/#{category.id}", :message => "Saved Category #{category.to_s}"
    else
      response.render "blog_admin/categories/new", :category => category, :blog => @blog
    end
  end

  def update(category_id, category_params)
    category = Category.get(category_id)
    category.attributes = category_params

    if category.save
      response.redirect "#{CaptainsBlog.root}/#{@blog.slug}/admin/categories/#{category.id}", :message => "Saved Category #{category.to_s}"
    else
      response.render "blog_admin/categories/show", :category => category, :blog => @blog
    end
  end

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