class Match < ActiveRecord::Base
  belongs_to :post
  belongs_to :matching, class_name: "Post"
  attr_accessible :keyword_coverage, :post_id, :matching_id

  default_scope order('created_at DESC')
  
end
