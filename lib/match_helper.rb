module MatchHelper
  def mail_users_of_posts_with_new_matches(users_and_posts_ids, ids_of_users_to_notify)
    ids_of_users_to_notify.each do |user_id|
      user_posts_ids_hash = users_and_posts_ids.select { |key, value| value == user_id}
      if user_posts_ids_hash.any?
        posts_ids = user_posts_ids_hash.keys
        UserMailer.notify_user_of_new_matches(user_id, posts_ids).deliver
      end
    end
  end
end