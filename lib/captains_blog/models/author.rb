class Author
  include DataMapper::Resource

  property :id, Serial
  property :byline, String

  belongs_to :blogs
  belongs_to :user

  def to_s
    return user.name if attribute_get(:byline).nil? or attribute_get(:byline).empty?

    attribute_get(:byline)
  end

  validates_present :byline, :if => Proc.new {|a| a.user_id.nil? }
end
