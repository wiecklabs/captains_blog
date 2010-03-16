class CaptainsBlog::BlogAdmin::Authors

  include PortAuthority::Authorization

  attr_accessor :request, :response, :blog

  protect "Authors", "list"
  def index
    response.render "blog_admin/authors/index", :authors => @blog.authors, :blog => @blog
  end

  protect "Authors", "create"
  def new
    response.render "blog_admin/authors/new", :users => User.all, :author => Author.new, :blog => @blog
  end

  protect "Authors", "update"
  def edit(author_id)
    author = Author.first(:id => author_id, :blog_id => @blog.id)
    response.render "blog_admin/authors/edit", :users => User.all, :author => author, :blog => @blog
  end

  protect "Authors", "update"
  def update(author_id, author_params)
    author = Author.first(:id => author_id, :blog_id => @blog.id)
    author.attributes = author_params

    if author.save
      response.redirect "#{CaptainsBlog.root}/admin/authors/#{author.id}", :message => "Saved Author \"#{author.to_s}\""
    else
      response.render "blog_admin/authors/edit", :users => User.all, :author => author, :blog => @blog
    end
  end

  protect "Authors", "create"
  def add(params)
    author = blog.authors.new(params)
    if author.save
      response.redirect "#{CaptainsBlog.root}/admin/authors/#{author.id}", :message => "Saved Author \"#{author.to_s}\""
    else
      response.render "blog_admin/authors/new", :users => User.all, :author => author, :blog => @blog
    end
  end

  protect "Authors", "destroy"
  def delete(author_id)
    author = Author.first(:id => author_id, :blog_id => @blog.id)
    
    if author.destroy
      response.redirect "#{CaptainsBlog.root}/admin/authors", :message => "Deleted Author \"#{author.to_s}\""
    else
      response.render "blog_admin/authors/edit", :users => User.all, :author => author, :blog => @blog
    end
  end
end