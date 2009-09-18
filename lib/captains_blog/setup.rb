class CaptainsBlog::Setup < Harbor::Application

  def self.routes(services)
    Harbor::Router.new do
      unless repository.adapter.storage_exists?("blogs") && Blog.count > 0
        using services, CaptainsBlog::Setup::Controller do
          get("/") { |setup| setup.index }
          post("/") { |setup, params| setup.setup(params["blog"], params["user"]) }
        end
      end
    end
  end

  class Controller
    attr_accessor :request, :response

    def index
      response.render 'setup/index', :layout => nil, :user => User.new, :blog => Blog.new
    end

    def setup(blog_params, user_params)
      user = User.new(user_params)
      blog = Blog.new(blog_params)

      user.valid?
      blog.valid?

      if user.valid? && blog.valid?
        DataMapper.auto_upgrade!

        admin_role = Role.create!(:name => "Admin", :description => "Site administrators")
        user.roles << admin_role
        user.save

        # We'll give our new user full permissions
        PermissionSet::permissions.each do |name, permissions|
          role = RolePermissionSet.new(:role => admin_role, :name => name)
          role.add *permissions
          role.save
          role.propagate_permissions!
        end

        blog.save

        request.application.router.clear
        request.session[:user_id] = user.id
        response.redirect "/"
      else
        response.render 'setup/index', :layout => nil, :user => user, :blog => blog
      end
    end
  end

end