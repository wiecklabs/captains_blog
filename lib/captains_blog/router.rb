class CaptainsBlog
  
  class Router < Harbor::Router
    class Using < Harbor::Router::Using

      %w(get post put delete).each do |verb|
        class_eval <<-EOS
        def #{verb}(matcher, &handler)
          @router.send(#{verb.inspect}, matcher) do |request, response|

            service = @container.get(@service_name, 
              :request => request, 
              :response => response, 
              :blog => Blog.first(:slug => request['blog_slug']),
              :logger => Logging::Logger[service]
            )

            handler.arity == 2 ? handler[service, request] : handler[service]
          end

        end
        EOS
      end

    end
  end

end

