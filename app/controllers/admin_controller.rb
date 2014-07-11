class AdminController < ApplicationController

  authorize_resource :class => false

  def index
    flagged_user_ids = ids_of_resources_with_excessive_flags(UserFlag, :flagged_id)
    flagged_post_ids = ids_of_resources_with_excessive_flags(PostFlag, :post_id)

    @flagged_users = User.where(id: flagged_user_ids)
    @flagged_posts = Post.where(id: flagged_post_ids)

    @new_users = User.new_joiners

    @excessive_flaggers = User.where(id: ids_of_users_who_flag_excessively)
  end

  def ids_of_resources_with_excessive_flags(flag_resource, id)
    ids_of_resources_with_flags = flag_resource.pluck(id)
    ids_of_resources_with_excessive_flags = determine_excessive_ids(ids_of_resources_with_flags)
    ids_of_resources_with_excessive_flags
  end

  def ids_of_users_who_flag_excessively
    user_flagger_ids = UserFlag.pluck(:flagger_id)
    post_flagger_ids = PostFlag.pluck(:flagger_id)

    flagger_ids = user_flagger_ids + post_flagger_ids
    ids_of_excessive_flaggers = determine_excessive_ids(flagger_ids)
    ids_of_excessive_flaggers
  end

  def determine_excessive_ids(ids)
    hash = Hash.new(0)
    ids.each { |id| hash[id] += 1 }
    excessive_ids_hash = hash.select { |id, count| count >= 10 }
    excessive_ids_hash.keys
  end
end
