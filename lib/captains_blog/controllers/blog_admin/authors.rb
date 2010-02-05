class CaptainsBlog::BlogAdmin::Authors

  include PortAuthority::Authorization

  attr_accessor :request, :response, :blog

  def add(user_id)
    blog.authors.new(:user_id => user_id).save!
  end

  def delete(author_id)
    blog.authors.delete(Author.get(author_id))

    @blog.save!
  end
end