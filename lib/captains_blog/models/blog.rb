class Blog

  include DataMapper::Resource

  property :id, Serial
  property :slug, String, :size => 100
  property :title, String, :size => 100
  property :tagline, String, :size => 200
  property :theme_name, String, :size => 50
  property :root_url, String, :size => 100

  validates_is_unique :slug
  validates_present :slug, :title

  has n, :posts

  has n, :authors

  has n, :taggings
  has n, :tags, :through => :taggings

  def root
    CaptainsBlog.root + "/#{slug}/"
  end

  def themed_post_path(path)
    if self.slug && self.theme_name
      File.join(self.slug, "themes", self.theme_name, path)
    else
      path
    end
  end

  def author?(user)
    user = user.id if user.is_a?(User)

    self.authors.first(:user_id => user)
  end

  def published_posts(conditions = nil)
    posts(:published => true, :published_at.not => nil, :published_at.lte => Time.now, :order => [:published_at.desc])
  end
end
