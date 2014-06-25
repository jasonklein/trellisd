class UserFlag < ActiveRecord::Base
  belongs_to :flagger, class_name: 'User'
  belongs_to :flagged, class_name: 'User'
  attr_accessible :flagger_id, :flagged_id

  validates :flagger_cannot_be_flagged, :flagger_cannot_flag_flagged_more_than_once

  def flagger_cannot_be_flagged
    errors.add("cannot flag self") if flagger_id == flagged_id
  end

  def flagger_cannot_flag_flagged_more_than_once
    flagings = UserFlag.where(flagger_id: flagger_id, flagged_id: flagged_id)
    errors.add("cannot flag multiple times") if flaggings.any?
  end
end
