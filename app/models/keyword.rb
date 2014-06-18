class Keyword < ActiveRecord::Base
  attr_accessible :title

  validates :title, presence: true

  has_and_belongs_to_many :posts
end
