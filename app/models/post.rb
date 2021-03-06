class Post < ActiveRecord::Base
  require 'action_view'

  include ActionView::Helpers::DateHelper

  attr_accessible :alert, :content, :expiration, :range, :title, :category_id, :user_id, :directionality, :last_matched

  belongs_to :user
  belongs_to :category
  has_and_belongs_to_many :keywords

  validates :title, :content, :expiration, :category_id, :user_id, :directionality, presence: true
  validates_length_of :keywords, minimum: 3, message: "field must have at least 3 keywords"
  validates_length_of :keywords, maximum: 10, message: "field cannot have more than 10 keywords"

  max_start_date = lambda { Date.today }
  max_end_date = lambda { Date.today + 3.months}
  validates_date :expiration,
    invalid_date_message: "must be a valid date",
    on_or_after: max_start_date,
    on_or_after_message: "must be on or after today",
    on_or_before: max_end_date,
    on_or_before_message: "must be on or before 3 months from today"


  has_many :matches, class_name: "Match", foreign_key: "post_id", dependent: :destroy
  has_many :inverse_matches, class_name: "Match", foreign_key: "matching_id", dependent: :destroy

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

  def filter_by_directionality(applicable_posts)
    if self.directionality == 'seeking'
      applicable_posts = applicable_posts.where(directionality: 'offering')
    else
      applicable_posts = applicable_posts.where(directionality: 'seeking')
    end
    applicable_posts
  end

  def directionality_category?
    directionality_categories = Category.where(title: ["work", "housing", "stuff"])
    directionality_category_ids = directionality_categories.map { |dc| dc.id }
    if directionality_category_ids.include?(self.category_id)
      true
    else
      false
    end
  end

  def get_posts_and_ids
    user = self.user
    connections_ids = user.all_connections_ids
    @applicable_posts = user.posts_of_connections_for_a_category(connections_ids, self.category_id)
  
    if @applicable_posts.any? && directionality_category?
      @applicable_posts = filter_by_directionality(@applicable_posts)
    end

    posts_and_ids = {}
    if @applicable_posts.any?
      @applicable_posts.each do |post|
        posts_ids = []
        post.keywords.each do |keyword|
          posts_ids << keyword.id
        end
        posts_and_ids[post.id] = posts_ids
      end
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

    if posts_to_compare.any?
      posts_to_compare.each do |post_id, keyword_ids|
        matching_keyword_ids = keyword_ids.select { |id| keyword_ids_to_match.include?(id) }
        posts_with_matching_keywords[post_id] = matching_keyword_ids.uniq
      end
    end

    matches = posts_with_matching_keywords.select { |post_id, matching_keyword_ids| matching_keyword_ids.length >= 3 }
    matches
  end

  def make_matches
    self.update_attributes(last_matched: Time.now)
    matches = find_matches
    if matches.any?
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

  ### Unsure how to pass the keywords back to the form
  ### in the edit view, the method below resets the posts
  ### keywords to the new keywords 

  def add_keywords(keyword_titles)
    self.keywords = []
    keyword_titles.each do |keyword_title|
      keyword = Keyword.where(title: keyword_title).first_or_create
      self.keywords << keyword
    end
    self.keywords = self.keywords.uniq
  end

  def destroy_keywords_posts
    keywords_posts = KeywordsPosts.where(post_id: self.id)
    keywords_posts.each do |kp|
      KeywordsPosts.destroy(kp)
    end
  end

  def has_recent_matches?
    self.has_new_matches? || self.has_possibly_unseen_matches? ? true : false
  end

  def has_new_matches?
    self.matches.where('created_at > ?', self.last_matched).any?
  end

  def has_possibly_unseen_matches?
    self.matches.where('created_at > ?', self.user.last_sign_in_at).any?
  end

  def new_matches
    self.matches.where('created_at > ?', self.last_matched)
  end
  

end
