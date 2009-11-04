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
  Harbor::View.layouts.map("articles/*", "layouts/blog")
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

      using services, CaptainsBlog::BlogAdmin::Articles do        
        get("#{root}/admin/articles") { |articles| articles.index }
        post("#{root}/admin/articles") { |articles, params| articles.create(params.fetch('article', {}), params.fetch('categories', [])) }
        get("#{root}/admin/articles/new") { |articles, params| articles.new }
        get("#{root}/admin/articles/:id") { |articles, params| articles.edit(params['id'].to_i) }
        put("#{root}/admin/articles/:id") { |articles, params| articles.update(params['id'].to_i, params.fetch('article', {}), params.fetch('categories', [])) }
        delete("#{root}/admin/articles/:id") { |articles, params| articles.delete(params['id'].to_i) }
      end

      using services, CaptainsBlog::BlogAdmin::Categories do
        get("#{root}/admin/categories") { |categories| categories.index }
        post("#{root}/admin/categories") { |categories, params| categories.create(params.fetch('category', {})) }
        get("#{root}/admin/categories/new") { |categories, params| categories.new }
        get("#{root}/admin/categories/:id") { |categories, params| categories.edit(params['id'].to_i) }
        put("#{root}/admin/categories/:id") { |categories, params| categories.update(params['id'].to_i, params.fetch('category', {})) }
        delete("#{root}/admin/categories/:id") { |categories, params| categories.delete(params['id'].to_i) }
      end

      using services, CaptainsBlog::Pages do
        get(root) { |blog_pages| blog_pages.index }
        get("#{root}/:yyyy/:mm/:dd/:article_slug") { |blog_pages, request| blog_pages.show(request['article_slug']) }
      end

      using services, CaptainsBlog::Comments do
        post("#{root}/:yyyy/:mm/:dd/:article_slug/comment") { |comments, request| comments.create(request['article_slug'], request['comment']) }
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

require "captains_blog/models/article"
require "captains_blog/models/blog"
require "captains_blog/models/category"
require "captains_blog/models/comment"
require "captains_blog/models/page"
require "captains_blog/models/page_attribute"
require "captains_blog/models/tag"
require "captains_blog/models/tagging"
require "captains_blog/models/template"

require "captains_blog/setup"
require "captains_blog/controllers/blogs"
require "captains_blog/controllers/comments"
require "captains_blog/controllers/pages"
require "captains_blog/controllers/blog_admin/articles"
require "captains_blog/controllers/blog_admin/blog"
require "captains_blog/controllers/blog_admin/categories"
require "captains_blog/controllers/blog_admin/links"

require "captains_blog/helpers"
