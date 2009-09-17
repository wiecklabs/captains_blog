module CaptainsBlog::Helpers

  # Swiped from merb_helpers 0.9.3
  def error_messages_for(obj, build_li = nil, html_class='error')
    raise ArgumentError.new("error_messages_for expects an object that responds to 'errors', got #{obj.inspect}") unless obj.respond_to?(:errors)

    return "" if obj.errors.empty?

    build_li ||= lambda{|err| "<li>#{err.join(' ')}</li>"}
    error_collection = obj.errors
    error_count = error_collection.size

    error_plurality = (error_count == 1 ? 'problem' : 'problems')
    header_message = "<h2>#{obj.new_record? ? 'Save' : 'Update'} failed because of #{error_count} #{error_plurality}</h2>"

    markup = %Q{
      <div class='#{html_class}'>
        #{header_message}
        <ul>
    }

    error_collection.each {|error, message| markup << build_li.call([error, message])}

    markup << %Q{
        </ul>
      </div>
    }
  end

  def category_links(categories)
    categories.map do |category|
      "<a href=\"/categories/#{category.slug}\">#{h(category.title)}</a>"
    end.join(', ')
  end

  def tag_links(tags)
    tags.map do |tag|
      "<a href=\"/tags/#{tag.name}\">#{h(tag.name)}</a>"
    end.join(', ')
  end

  def comments_panel(post)
    return render(@blog.page('_comments'), :post => post)
  end

end

Harbor::ViewContext.send(:include, CaptainsBlog::Helpers)