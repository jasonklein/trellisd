class Post < ActiveRecord::Base
  attr_accessible :alert, :content, :expiration, :range, :title, :category_id, :user_id
end
