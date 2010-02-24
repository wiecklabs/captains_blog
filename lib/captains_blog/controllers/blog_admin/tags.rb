class CaptainsBlog::BlogAdmin::Tags

  include PortAuthority::Authorization

  attr_accessor :request, :response, :blog

  # protect "Authors", "list"
  def index
    response.render "blog_admin/tags/index", :blog => @blog
  end

  def delete(tag_id)
    message = if Tagging.all(:blog_id => @blog.id, :tag_id => tag_id).destroy!
      "Removed tag \"#{Tag.get(tag_id).name}\""
    else
      "An error ocurred while removing tag \"#{Tag.get(tag_id).name}\""
    end

    response.redirect "#{CaptainsBlog.root}/#{@blog.slug}/admin/tags", :message => message
  end

end