module MessagesHelper
  def display_recipient_name(recipient_id)
    recipient = User.find(recipient_id)
    recipient.name
  end

  def display_original_content_label
    if @original_content
      label_tag 'Original Message'
    end 
  end

  def display_original_content
    if @original_content
      simple_format @original_content
    end
  end
end
