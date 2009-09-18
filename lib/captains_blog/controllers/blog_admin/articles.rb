class CaptainsBlog::BlogAdmin::Articles
  
  attr_accessor :request, :response, :logger, :blog

  def index
    response.render "blog_admin/articles/index", :layout => "layouts/blog_admin", :articles => Article.all, :blog => @blog
  end

  def show(article_id)
    response.render "blog_admin/articles/show", :layout => "layouts/blog_admin", :article => Article.get(article_id), :blog => @blog
  end

  def new
    response.render "blog_admin/articles/new", :layout => "layouts/blog_admin", :article => Article.new, :blog => @blog
  end

  def edit(article_id)
    response.render "blog_admin/articles/edit", :layout => "layouts/blog_admin", :article => Article.get(article_id), :blog => @blog
  end

  def create(article_params, category_params)
    article = Article.new
    article.blog = @blog
    article.attributes = article_params
    article.categories = Category.all(:id => category_params)

    if article.save
      response.redirect "#{CaptainsBlog.root}/#{@blog.slug}/admin/articles/#{article.id}", :layout => "layouts/blog_admin", :message => "Saved Article #{article.to_s}"
    else
      response.render "blog_admin/articles/new", :layout => "layouts/blog_admin", :article => article, :blog => @blog
    end
  end

  def update(article_id, article_params, category_params)
    article = Article.get(article_id)
    article.attributes = article_params
    article.categories.clear
    article.save

    article.categories = Category.all(:id => category_params)

    if article.save
      response.redirect "#{CaptainsBlog.root}/#{@blog.slug}/admin/articles/#{article.id}", :layout => "layouts/blog_admin", :message => "Saved Article #{article.to_s}"
    else
      response.render "blog_admin/articles/show", :layout => "layouts/blog_admin", :article => article, :blog => @blog
    end
  end

  def delete(article_id)
    article = Article.get(article_id)

    if request.xhr?
      return response.puts(article.destroy)
    else
      if article.destroy
        response.redirect "#{CaptainsBlog.root}/#{@blog.slug}/admin/articles", :layout => "layouts/blog_admin", :message => "Deleted Article #{article.to_s}"
      else
        response.render "blog_admin/articles/show", :layout => "layouts/blog_admin", :article => article
      end
    end
  end

end