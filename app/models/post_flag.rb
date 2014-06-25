class PostFlag < ActiveRecord::Base
  belongs_to :flagger
  belongs_to :post
  # attr_accessible :title, :body
end
