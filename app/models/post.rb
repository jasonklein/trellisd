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

  def get_posts_and_ids
    connections_posts_in_same_category = self.user.posts_of_connections_for_a_category(self.category_id)
    posts_and_ids = {}
    connections_posts_in_same_category.each do |post|
      posts_ids = []
      post.keywords.each do |keyword|
        posts_ids << keyword.id
      end
      posts_and_ids[post.id] = posts_ids
    end
    posts_and_ids
  end

  def matches
    posts_to_compare = self.get_posts_and_ids
    keyword_ids_to_match = self.keyword_ids
    posts_with_matching_keywords = {}
    posts_to_compare.each do |post_id, keyword_ids|
      matching_keyword_ids = keyword_ids.select { |id| keyword_ids_to_match.include?(id) }
      posts_with_matching_keywords[post_id] = matching_keyword_ids
    end
    posts_with_matching_keywords = posts_with_matching_keywords.reject { |post_id, keyword_ids| keyword_ids.length < 3 }
  end


end
