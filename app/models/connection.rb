class Connection < ActiveRecord::Base
  belongs_to :connecter
  belongs_to :connectee
  # attr_accessible :title, :body
end
