class Message < ActiveRecord::Base
  belongs_to :sender
  belongs_to :recipient
  attr_accessible :content, :recipient_readability, :sender_readability, :viewed, :sender_id, :recipient_id

  belongs_to :sender, class_name: "User"
  belongs_to :recipient, class_name: "User"

  validates :content, :sender_id, :recipient_id, presence: true

  default_scope order('created_at DESC')
  scope :unviewed, where(viewed: false)

  def date
    self.created_at.strftime('%d %b %y')
  end

  def new_since_last_login?(user)
    self.created_at > user.last_sign_in_at
  end

  def recipient_is_current_user?(user)
    self.recipient == user
  end

  def classname_for_user(user)
    if recipient_is_current_user?(user)
      self.new_since_last_login?(user) ? 'warning' : 'info'
    end
  end

  def toggle_readability_or_destroy(user)
    if self.sender_readability == false || self.recipient_readability == false
      self.destroy
    elsif self.sender == user
      self.update_attributes(sender_readability: false)
    else
      self.update_attributes(recipient_readability: false)
    end  
  end
end
