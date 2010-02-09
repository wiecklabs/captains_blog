PermissionSet::permissions["Authors"] = [
  "list",
  "create",
  "update",
  "destroy"
]

module PortAuthority::Authorization::ClassMethods
   def deny_unless_author
     deny { |c| not c.blog.author?(c.request.session.user) }
   end
end