class CaptainsBlog
  
  class Router < Harbor::Router
    class Using < Harbor::Router::Using
      #Now with less evi-- I mean eval...
      def blog_route(handler)
        Proc.new do |request, response|
          service = @container.get(@service_name,
                                   :request => request,
                                   :response => response,
                                   :blog => Blog.first(:slug => request['blog_slug']),
                                   :logger => Logging::Logger[service])

          handler.arity == 2 ? handler[service, request] : handler[service]
        end
      end

      def get(matcher, &handler)
        @router.send(:get, matcher, &blog_route(handler))
      end

      def post(matcher, &handler)
        @router.send(:post, matcher, &blog_route(handler))
      end

      def put(matcher, &handler)
        @router.send(:put, matcher, &blog_route(handler))
      end
      
      def delete(matcher, &handler)
        @router.send(:delete, matcher, &blog_route(handler))
      end

    end

  end

end

