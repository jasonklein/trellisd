class SuggestedConnection < ActiveRecord::Base
  belongs_to :user
  belongs_to :connectee, class_name: 'User'
  attr_accessible :user_id, :connectee_id

  validates :user_id, :connectee_id, presence: true
end
