class Tagging
  
  include DataMapper::Resource

  property :blog_id, Integer, :key => true
  property :post_id, Integer, :key => true
  property :tag_id, Integer, :key => true

  belongs_to :blog
  belongs_to :post
  belongs_to :tag

end