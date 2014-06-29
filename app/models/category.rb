class Category < ActiveRecord::Base
  attr_accessible :icon, :title

  has_many :posts

  def display_title
    case title
    when 'knowledge'
      'Knowledge and Miscellaneous'
    when 'pdq'
      'PDQ'
    else
      title.capitalize
    end
  end
  
end
