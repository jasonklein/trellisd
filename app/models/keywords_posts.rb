class KeywordsPosts < ActiveRecord::Base
  belongs_to :keyword
  belongs_to :post
  # attr_accessible :title, :body
end
