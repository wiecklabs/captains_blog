class CaptainsBlog::BlogAdmin::Authors

  include PortAuthority::Authorization

  attr_accessor :request, :response, :blog

  protect
  def index
    response.render "blog_admin/authors/index", :authors => @blog.authors, :blog => @blog
  end

  protect
  def new
    response.render "blog_admin/authors/new", :users => User.all, :author => Author.new, :blog => @blog
  end

  protect
  def edit(author_id)
    author = Author.first(:id => author_id, :blog_id => @blog.id)
    response.render "blog_admin/authors/edit", :users => User.all, :author => author, :blog => @blog
  end

  protect
  def update(author_id, author_params)
    author = Author.first(:id => author_id, :blog_id => @blog.id)
    author.attributes = author_params

    if author.save
      response.redirect "#{CaptainsBlog.root}/#{@blog.slug}/admin/authors/#{author.id}", :message => "Saved Author \"#{author.to_s}\""
    else
      response.render "blog_admin/authors/edit", :users => User.all, :author => author, :blog => @blog
    end
  end

  # TODO protect methods below and remember that tests will break
  def add(params)
    author = blog.authors.new(params)
    if author.save
      response.redirect "#{CaptainsBlog.root}/#{@blog.slug}/admin/authors/#{author.id}", :message => "Saved Author \"#{author.to_s}\""
    else
      response.render "blog_admin/authors/new", :users => User.all, :author => author, :blog => @blog
    end
  end

  def delete(author_id)
    author = Author.first(:id => author_id, :blog_id => @blog.id)
    
    if author.destroy
      response.redirect "#{CaptainsBlog.root}/#{@blog.slug}/admin/authors", :message => "Deleted Author \"#{author.to_s}\""
    else
      response.render "blog_admin/authors/edit", :users => User.all, :author => author, :blog => @blog
    end
  end
end