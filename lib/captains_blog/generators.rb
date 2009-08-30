class CaptainsBlog

  module Generators

    class Bootstrap

      Harbor::Generator.register('captains_blog', 'bootstrap', self)

      def initialize(options)
        @options = options
      end

      def run
        root = Pathname(CaptainsBlog.blog_repository)

        default_theme_source_path = Pathname(__FILE__).dirname + 'generators' + 'skeletons' + 'default_theme'
        default_theme_installation_path = root + 'default' + 'themes' + 'default'

        puts "Adding default blog in #{root}"
        FileUtils.mkdir_p(default_theme_installation_path)
        FileUtils.cp(Dir[default_theme_source_path + "*"], default_theme_installation_path)

        default_blog = Blog.first_or_create(:slug => 'default')
        default_blog.title ||= 'Default Blog'
        default_blog.title ||= 'The best little blog on Harbor'
        default_blog.theme_name ||= 'default'
        default_blog.save!
      end

    end

    class AddBlogCommand

      Harbor::Generator.register('captains_blog', 'add_blog', self)

      def initialize(options)
        @options = options
      end

      def run
        puts "Adding a blog: #{@options.inspect}"
      end

    end

  end

end
