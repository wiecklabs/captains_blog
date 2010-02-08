require "rubygems"
require "pathname"

$:.unshift(Pathname(__FILE__).dirname.expand_path)

gem "harbor", ">= 0.12.7"
require "harbor"
require "harbor/logging"

gem "dm-is-tree"
require "dm-is-tree"
require "dm-is-tree/is/version"

gem "port_authority", ">= 1.0"
require "port_authority"

gem "RedCloth"
require "redcloth"

class CaptainsBlog < Harbor::Application
  
  require "captains_blog/router"

  module Admin; end
  module BlogAdmin; end

  Harbor::View::path.unshift(Pathname(__FILE__).dirname + "captains_blog/views")  
  
  Harbor::View.layouts.map("blog_admin/*", "layouts/blog_admin")
  Harbor::View.layouts.map("posts/*", "layouts/blog")
  Harbor::View.layouts.map("*", "layouts/application")

  def self.public_path
    Pathname(__FILE__).dirname.parent + "public"
  end

  def self.root
    @root || '/blogs'
  end

  def self.root=(value)
    @root = value
  end

  def self.blog_repository
    @blog_repository
  end

  def self.blog_repository=(value)
    Harbor::View::path.unshift(value)

    @blog_repository = value
  end

  @@public_comments_enabled = true
  def self.disable_public_comments!
    @@public_comments_enabled = false
  end

  def self.public_comments_enabled?
    @@public_comments_enabled
  end
  
  @@require_approvals = false
  def self.require_approvals
    @@require_approvals = true
    Comment.require_approvals!
  end

  def self.approvals_required?
    @@require_approvals
  end

  def self.routes(services = self.services)
    raise ArgumentError.new("+services+ must be a Harbor::Container") unless services.is_a?(Harbor::Container)

    CaptainsBlog::Router.new do
      root = (CaptainsBlog.root + "/:blog_slug").squeeze("/")
      
      using services, CaptainsBlog::Blogs do
        get("/admin/blogs")           { |blogs| blogs.index }
        post("/admin/blogs")          { |blogs, request| blogs.create(request['blog']) }
        get("/admin/blogs/new")       { |blogs, request| blogs.new }
        get("/admin/blogs/:id")       { |blogs, request| blogs.response.redirect("/admin/blogs/#{request['id']}/edit") }
        get("/admin/blogs/:id/edit")  { |blogs, request| blogs.edit(request['id'].to_i) }
        put("/admin/blogs/:id")       { |blogs, request| blogs.update(request['id'].to_i, request['blog']) }
      end

      using services, CaptainsBlog::BlogAdmin::Blog do
        get("#{root}/admin") { |blog| blog.dashboard }
      end

      using services, CaptainsBlog::BlogAdmin::Posts do        
        get("#{root}/admin/posts") { |posts| posts.index }
        post("#{root}/admin/posts") { |posts, params| posts.create(params.fetch('post', {}), params.fetch('categories', [])) }
        get("#{root}/admin/posts/new") { |posts, params| posts.new }
        get("#{root}/admin/posts/:id") { |posts, params| posts.edit(params['id'].to_i) }
        put("#{root}/admin/posts/:id") { |posts, params| posts.update(params['id'].to_i, params.fetch('post', {}), params.fetch('categories', [])) }
        delete("#{root}/admin/posts/:id") { |posts, params| posts.delete(params['id'].to_i) }
      end

      using services, CaptainsBlog::BlogAdmin::Categories do
        get("#{root}/admin/categories") { |categories| categories.index }
        post("#{root}/admin/categories") { |categories, params| categories.create(params.fetch('category', {})) }
        get("#{root}/admin/categories/new") { |categories, params| categories.new }
        get("#{root}/admin/categories/:id") { |categories, params| categories.edit(params['id'].to_i) }
        put("#{root}/admin/categories/:id") { |categories, params| categories.update(params['id'].to_i, params.fetch('category', {})) }
        delete("#{root}/admin/categories/:id") { |categories, params| categories.delete(params['id'].to_i) }
      end

      using services, CaptainsBlog::BlogAdmin::Authors do
        get("#{root}/admin/authors") { |authors| authors.index }
        post("#{root}/admin/authors") { |authors, params| authors.add(params.fetch('author', {})) }
        get("#{root}/admin/authors/new") { |authors, params| authors.new }
        get("#{root}/admin/authors/:id") { |authors, params| authors.edit(params['id'].to_i) }
        put("#{root}/admin/authors/:id") { |authors, params| authors.update(params['id'].to_i, params.fetch('author', {})) }
        delete("#{root}/admin/authors/:id") { |authors, params| authors.delete(params['id'].to_i) }
      end

      using services, CaptainsBlog::BlogAdmin::Comments do
        get("#{root}/admin/posts/:id/comments") { |comments, params| comments.index(params['id'].to_i)}
        get("#{root}/admin/comments/:comment_id/approve") { |comments, params| comments.approve(params['comment_id'].to_i)}
        get("#{root}/admin/comments/:comment_id/disapprove") { |comments, params| comments.disapprove(params['comment_id'].to_i)}
      end

      using services, CaptainsBlog::Comments do
        post("#{root}/:yyyy/:mm/:dd/:post_slug/comment") { |comments, request| comments.create(request['post_slug'], request['comment']) }
      end
      
      using services, CaptainsBlog::Posts do
        get("#{root}") {|blog_posts, request| blog_posts.index }
        get("#{root}/:yyyy/:mm/:dd/:post_slug") { |blog_posts, request| blog_posts.show(request['post_slug']) }
      end

    end

  end

  class AllBlogThemes < Harbor::Application

    def self.public_path
      CaptainsBlog.blog_repository
    end

    def self.routes(services = self.services)
      Harbor::Router.new {}
    end
  end

end

class Fixnum
	def self.ordinal(number)
		to_s + ([[nil, 'st','nd','rd'],[]][number % 100 / 10 == 1 ? 1 : 0][number % 10] || 'th')
	end
end

# TODO: What about setting up an autoloader?

require "captains_blog/models/post"
require "captains_blog/models/blog"
require "captains_blog/models/category"
require "captains_blog/models/comment"
require "captains_blog/models/tag"
require "captains_blog/models/tagging"
require "captains_blog/models/template"
require "captains_blog/models/author"

require "captains_blog/setup"
require "captains_blog/controllers/blogs"
require "captains_blog/controllers/comments"
require "captains_blog/controllers/posts"
require "captains_blog/controllers/blog_admin/posts"
require "captains_blog/controllers/blog_admin/authors"
require "captains_blog/controllers/blog_admin/blog"
require "captains_blog/controllers/blog_admin/categories"
require "captains_blog/controllers/blog_admin/links"
require "captains_blog/controllers/blog_admin/comments"

require "captains_blog/helpers"
