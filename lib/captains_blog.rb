require 'rubygems'

gem "harbor", ">= 0.10.2"
require "harbor"
require "harbor/logging"

gem "dm-is-tree"
require "dm-is-tree"

gem "port_authority", ">= 1.0"
require "port_authority"

class Fixnum
	def self.ordinal(number)
		to_s + ([[nil, 'st','nd','rd'],[]][number % 100 / 10 == 1 ? 1 : 0][number % 10] || 'th')
	end
end

class CaptainsBlog < Harbor::Application

  module Admin; end
  module BlogAdmin; end

  class Router < Harbor::Router
    class Using < Harbor::Router::Using

      %w(get post put delete).each do |verb|
        class_eval <<-EOS
        def #{verb}(matcher, &handler)
          @router.send(#{verb.inspect}, matcher) do |request, response|
            # TODO: Determine Active Blog based on request (hostname/hash lookup?)
            active_blog = Blog.first
            
            service = @container.get(@service_name, 
              :request => request, 
              :response => response, 
              :blog => active_blog
              # :logger => Logging::Logger[service]
            )

            handler.arity == 2 ? handler[service, request] : handler[service]
          end
        end
        EOS
      end

    end
  end

  Dir[Pathname(__FILE__).dirname + "captains_blog/models/*.rb"].each { |r| require r }
  Dir[Pathname(__FILE__).dirname + "captains_blog/controllers/**/**.rb"].each { |r| require r }

  # Harbor::View::path.unshift(Pathname(__FILE__).dirname + "captains_blog/themes")
  Harbor::View::path.unshift(Pathname(__FILE__).dirname + "captains_blog/views")  

  def default_layout
    ["inove/default"] #, "layouts/application", "layouts/admin"]
  end

  def self.root
    (Pathname(__FILE__).dirname + "captains_blog").expand_path
  end

  def self.script_root
    root + "script"
  end

  def self.public_path
    root + "public"
  end

  def self.private_path
    root + "private"
  end

  def self.temp_path
    root + "tmp"
  end
  
  def self.root
    @root || '/blog'
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

  def self.routes(services = self.services)
    raise ArgumentError.new("+services+ must be a Harbor::Container") unless services.is_a?(Harbor::Container)

    CaptainsBlog::Router.new do

      using services, CaptainsBlog::Blogs do
        get("/admin/blogs")           { |blogs| blogs.index }
        get("/admin/blogs/:id")       { |blogs, request| blogs.response.redirect("/admin/blogs/#{request['id']}/edit") }
        get("/admin/blogs/:id/edit")  { |blogs, request| blogs.edit(request['id'].to_i) }
        put("/admin/blogs/:id")       { |blogs, request| blogs.update(request['id'].to_i, request['blog']) }
      end

      using services, CaptainsBlog::BlogAdmin::Blog do
        get("/blog-admin") { |blog| blog.dashboard }
      end

      using services, CaptainsBlog::BlogAdmin::Articles do        
        get("/blog-admin/articles") { |articles| articles.index }
        post("/blog-admin/articles") { |articles, params| articles.create(params.fetch('article', {}), params.fetch('categories', [])) }
        get("/blog-admin/articles/new") { |articles, params| articles.new }
        get("/blog-admin/articles/:id") { |articles, params| articles.edit(params['id'].to_i) }
        put("/blog-admin/articles/:id") { |articles, params| articles.update(params['id'].to_i, params.fetch('article', {}), params.fetch('categories', [])) }
        delete("/blog-admin/articles/:id") { |articles, params| articles.delete(params['id'].to_i) }
      end

      using services, CaptainsBlog::BlogAdmin::Categories do
        get("/blog-admin/categories") { |categories| categories.index }
        post("/blog-admin/categories") { |categories, params| categories.create(params.fetch('category', {})) }
        get("/blog-admin/categories/new") { |categories, params| categories.new }
        get("/blog-admin/categories/:id") { |categories, params| categories.edit(params['id'].to_i) }
        put("/blog-admin/categories/:id") { |categories, params| categories.update(params['id'].to_i, params.fetch('category', {})) }
        delete("/blog-admin/categories/:id") { |categories, params| categories.delete(params['id'].to_i) }

      end

      using services, CaptainsBlog::Pages do
        get("/") { |blog_pages| blog_pages.index }
        get(/.*/) { |blog_pages, request| blog_pages.handle_page_request(request.path) }
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

require Pathname(__FILE__).dirname + "captains_blog/helpers"