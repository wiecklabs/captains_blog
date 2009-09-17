class Blog

  include DataMapper::Resource

  property :id, Serial
  property :slug, String, :size => 100
  property :title, String, :size => 100
  property :tagline, String, :size => 200
  property :theme_name, String, :size => 50
  property :root_url, String, :size => 100

  # validate_unique :slug

  has n, :articles

  has n, :taggings
  has n, :tags, :through => :taggings

  def page(path)
    if self.slug && self.theme_name
      File.join(self.slug, "themes", self.theme_name, path)
    else
      path
    end
  end

end