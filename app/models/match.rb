class Match < ActiveRecord::Base
  belongs_to :post, class_name: "Post"
  belongs_to :matching, class_name: "Post"
  attr_accessible :keyword_coverage, :post_id, :matching_id
end
