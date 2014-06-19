module MessagesHelper
  def display_recipient_name(recipient_id)
    recipient = User.find(recipient_id)
    recipient.name
  end
end
