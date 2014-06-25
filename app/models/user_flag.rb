class UserFlag < ActiveRecord::Base
  belongs_to :flagger, class_name: 'User'
  belongs_to :flagged, class_name: 'User'
  attr_accessible :flagger_id, :flagged_id

  validate :flagger_cannot_be_flagged, :flagger_cannot_flag_flagged_more_than_once

  def flagger_cannot_be_flagged
    errors.add(:user, "cannot flag self") if flagger_id == flagged_id
  end

  def flagger_cannot_flag_flagged_more_than_once
    user_flags = UserFlag.where(flagger_id: flagger_id, flagged_id: flagged_id)
    errors.add(:user, "has already been flagged by you") if user_flags.any?
  end

  def errors_for_redirect
    self.errors.full_messages.join(", ").downcase.capitalize
  end
end
