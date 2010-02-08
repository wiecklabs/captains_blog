class CaptainsBlog::BlogAdmin::Authors

  include PortAuthority::Authorization

  attr_accessor :request, :response, :blog

  def add(params)
    blog.authors.new(params).save
  end

  def delete(author_id)
    blog.authors.delete(Author.get(author_id))

    @blog.save!
  end
end