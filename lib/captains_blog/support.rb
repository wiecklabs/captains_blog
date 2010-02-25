class String
  def slugize
    downcase.gsub(/\W/, '-').squeeze('-')
  end
end