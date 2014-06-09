class KeywordsPosts < ActiveRecord::Base
  belongs_to :keyword
  belongs_to :post
  attr_accessible :keyword_id, :post_id
end
