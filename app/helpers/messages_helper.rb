module MessagesHelper
  def display_recipient_name(recipient_id)
    recipient = User.find(recipient_id)
    recipient.name
  end

  def display_original_or_post_content_label
    if @original_content
      label_tag 'Original Message'
    elsif @post_content
      label_tag 'Post Content'
    end 
  end

  def display_original_or_post_content
    if @original_content
      simple_format @original_content
    elsif @post_content
      simple_format @post_content
    end
  end
end
