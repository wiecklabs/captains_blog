class Post 

	include DataMapper::Resource
	include DataMapper::Timestamp

	property :id, Serial
	# TODO why do we need this?
	property :type, Discriminator
	property :slug, String, :size => 200
	property :title, String, :size => 300
	property :content, Text
	property :published, Boolean, :default => false
	property :published_at, DateTime
	property :accepting_comments, Boolean, :default => true
	property :comment_count, Integer, :default => 0
	property :template_name, String, :size => 50

	belongs_to :blog
	has n, :comments

  belongs_to :author

	has n, :taggings
	has n, :tags, :through => :taggings

  has n, :categories, :through => Resource

  validates_present :published_at,  :when => [ :publish ]
  validates_present :title,         :when => [ :publish ]
  validates_present :content,       :when => [ :draft, :publish ]
  validates_absent  :published,     :when => [ :draft ]

  before :save do
    if slug.blank? && title
      self.slug = title.downcase.gsub(/\W/, '-').squeeze('-')
    end
  end

	def to_s
    title.blank? ? "Untitled" : title
  end

  def path
    return "posts/#{id}" unless published

    "#{published_at.strftime("%Y/%m/%d")}/#{slug}"
  end

  def approved_comments
    if Comment.require_approvals?
      comments(:approved => true)
    else
      comments
    end
  end

  def publish!
    if valid?(:publish)
      @published = true
      save!
    end
  end
end
