# Permissions
PermissionSet::permissions["Blogs"] = [
  "index: List All Blogs",
  "create: Create a new Blog",
  "update: Update an existing Blog"
]

PermissionSet::permissions["BlogPosts"] = [
  "list: List All Blog Posts",
  "show: Show a Single Blog Post",
  "comment: Comment on a Blog Post"
]

PermissionSet::permissions["Authors"] = [
  "list: Display the list of Authors",
  "create: Create a new Author",
  "update: Update an existing Author",
  "destroy: Delete an Author"
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
