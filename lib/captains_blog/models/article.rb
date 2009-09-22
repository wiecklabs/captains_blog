class Article

	include DataMapper::Resource
	include DataMapper::Timestamp

	property :id, Serial
	property :type, Discriminator
	property :slug, String, :size => 200
	property :title, String, :size => 300
	property :byline, String, :size => 200
	property :content, Text
	property :published_at, DateTime, :default => lambda { Time.now }
	property :accepting_comments, Boolean, :default => true
	property :comment_count, Integer, :default => 0
	property :template_name, String, :size => 50

	belongs_to :blog
  # has n, :post_attributes
	has n, :comments

	has n, :taggings
	has n, :tags, :through => :taggings

  # has n, :categorizations
  # has n, :categories, :through => :categorizations
  has n, :categories, :through => Resource

	def to_s
    title.blank? ? "Untitled" : title
  end

  def path
    "#{published_at.strftime("%Y/%m/%d")}/#{slug}"
  end

end

class Post < Article
end

# class Page < Article
# end