class PostAttribute
  
  include DataMapper::Resource

  property :id, Serial
  property :key, String, :size => 50
  property :content, Text, :lazy => false

  belongs_to :post
end