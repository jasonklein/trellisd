class User < ActiveRecord::Base
  attr_accessible :bio, :birthday, :city, :email, :first_name, :image, :last_name, :postcode
end
