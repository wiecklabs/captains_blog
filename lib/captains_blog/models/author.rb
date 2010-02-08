class Author
  include DataMapper::Resource

  property :id, Serial
  property :byline, String

  belongs_to :blogs
  belongs_to :user

  def to_s
    return user.name unless user.nil? or attribute_get(:byline)

    attribute_get(:byline)
  end

  validates_present :byline, :if => Proc.new {|a| a.user_id.nil? }
end
