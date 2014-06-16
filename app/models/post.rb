class Post < ActiveRecord::Base
  attr_accessible :alert, :content, :expiration, :range, :title, :category_id, :user_id

  belongs_to :user
  belongs_to :category
  has_and_belongs_to_many :keywords

  has_many :matches, class_name: "Match", foreign_key: "post_id"
  has_many :inverse_matches, class_name: "Match", foreign_key: "matching_id"

  default_scope order('created_at DESC')

  def get_keyword_ids
    if !@keyword_ids
      @keyword_ids = []
      self.keywords.each { |keyword| @keyword_ids << keyword.id }
      @keyword_ids = @keyword_ids.uniq
    end
    @keyword_ids
  end

  def list_keyword_titles
    titles = []
    keywords.each do |keyword|
      titles << keyword.try(:title)
    end
    titles = titles.sort.uniq.compact
    titles.join(" | ")
  end

  def get_posts_and_ids
    user = self.user
    connections_ids = user.all_connections_ids
    connections_posts_in_same_category = user.posts_of_connections_for_a_category(connections_ids, self.category_id)
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

  def calculate_keyword_coverage (keyword_ids_to_match, keyword_ids)
    unmatched_ids = keyword_ids_to_match - keyword_ids
    coverage_numerator = (keyword_ids_to_match.count - unmatched_ids.count).to_f
    coverage_denominator = (keyword_ids_to_match.count).to_f
    keyword_coverage = ((coverage_numerator/coverage_denominator) * 100).round
    keyword_coverage
  end

  def find_matches
    posts_to_compare = get_posts_and_ids
    keyword_ids_to_match = get_keyword_ids
    posts_with_matching_keywords = {}

    posts_to_compare.each do |post_id, keyword_ids|
      matching_keyword_ids = keyword_ids.select { |id| keyword_ids_to_match.include?(id) }
      posts_with_matching_keywords[post_id] = matching_keyword_ids.uniq
    end

    matches = posts_with_matching_keywords.select { |post_id, matching_keyword_ids| matching_keyword_ids.length >= 3 }
    matches
  end

  def make_matches
    matches = find_matches
    matches.each do |matching_id, matching_keyword_ids|
      keyword_coverage = calculate_keyword_coverage(get_keyword_ids, matching_keyword_ids)
      duplicates = Match.where(post_id: self.id, matching_id: matching_id)
      if duplicates.any?
        duplicates.first.update_attributes(keyword_coverage: keyword_coverage)
      else
        Match.create(
          post_id: self.id,
          matching_id: matching_id,
          keyword_coverage: keyword_coverage
          )
      end
    end
  end


end
