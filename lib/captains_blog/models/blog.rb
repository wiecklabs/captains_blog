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

  def page(key)
    (Pathname(CaptainsBlog.blog_repository) + self.slug + "themes" + self.theme_name + "#{key}.html.erb").expand_path
  end

end