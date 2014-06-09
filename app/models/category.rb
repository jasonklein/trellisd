class Category < ActiveRecord::Base
  attr_accessible :icon, :title

  has_many :posts
  
end
