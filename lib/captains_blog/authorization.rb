PermissionSet::permissions["Authors"] = [
  "list",
  "create",
  "update",
  "destroy"
]

module CaptainsBlog::Authorization
  def self.included(base)
    base.send(:include, PortAuthority::Authorization)
    
    base.extend ClassMethods
  end

  module ClassMethods
    def deny_unless_author
      deny { |c| not c.blog.author?(c.request.session.user) }
    end
  end
end