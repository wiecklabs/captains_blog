class Author
  include DataMapper::Resource

  property :id, Serial

  belongs_to :blogs
  belongs_to :user
end
