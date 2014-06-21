module PostsHelper

  def display_matches_count_if_current_user_post(post)
    if post.user == current_user
      "Matches: #{post.matches.count}"
    end
  end

  def current_user_and_matches?(post)
    (post.user == current_user && post.matches.any?) ? true : false
  end

  def display_match(match)
    render partial: 'users/post_box', locals: {post: match.matching, match: match}
  end

  def expiration_message(post)
    if post.expiration <= Date.today
      "Expires today."
    elsif post.expiration == Date.tomorrow
      "Expires tomorrow."
    else
      "Expires in #{post.distance_of_time_in_words_to_now(post.expiration)}."
    end
  end

end
