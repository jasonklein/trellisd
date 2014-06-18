class Connection < ActiveRecord::Base
  attr_accessible :connecter_id, :connectee_id, :state

  validates :connecter_id, :connectee_id, :state, presence: true

  belongs_to :connecter, class_name: "User"
  belongs_to :connectee, class_name: "User"
end
