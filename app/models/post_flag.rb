class PostFlag < ActiveRecord::Base
  belongs_to :flagger, class_name: "User"
  belongs_to :post
  attr_accessible :flagger_id, :post_id

  validates :flagger_id, :post_id, presence: true
  validate :flagger_cannot_flag_own_post, :flagger_cannot_flag_post_more_than_once

  def flagged_post_user_id
    post_user = post.user
    post_user_id = post_user.id
    post_user_id
  end

  def flagger_cannot_flag_own_post
    errors.add(:user, "cannot flag own post") if flagger_id == flagged_post_user_id
  end

  def flagger_cannot_flag_post_more_than_once
    post_flags = PostFlag.where(flagger_id: flagger_id, post_id: post_id)
    errors.add(:post, "has already been flagged by you") if post_flags.any?
  end

  def errors_for_redirect
    self.errors.full_messages.join(", ").downcase.capitalize
  end
end
