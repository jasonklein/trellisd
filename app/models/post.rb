class Post < ActiveRecord::Base
  attr_accessible :alert, :content, :expiration, :range, :title, :category_id, :user_id

  belongs_to :user
  belongs_to :category
  has_and_belongs_to_many :keywords

  # finds posts made by those connected to a particular user
  # finds the ones with matching keywords
  # rejects ones where the number of matching keywords are less than 3
  # returns the array of matching posts

  def get_keyword_ids
    keyword_ids = []
    self.keywords.each { |keyword| keyword_ids << keyword.id }
    keyword_ids
  end

  def matches

    connections_posts_in_same_category = self.user.posts_of_connections_for_a_category(self.category_id)


  end

end
