class Category
  include DataMapper::Resource

  property :blog_id, Integer
  property :id, Serial
  property :title, String, :size => 255
  property :notes, Text, :lazy => false
  property :slug, String, :size => 100
  property :position, Integer

  if DataMapper::Is::Tree::VERSION < "0.9.8"
    is :tree, :order => [:position]
  else
    is :tree, :order => :position
  end

  belongs_to :blog

  def path
    category = self
    parents = [self]

    while (parent = category.parent)
      parents.unshift(parent)
      category = parent
    end

    parents
  end

  def to_s
    path.map { |category| category.title }.join(" > ")
  end

end