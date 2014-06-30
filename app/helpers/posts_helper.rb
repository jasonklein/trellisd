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

  def display_edit_if_current_user_post(user, post)
    if user == current_user
      button_to "Edit", edit_post_path(post), method: :get
    end
  end

  def display_delete_if_current_user_post(user, post)
    if user == current_user
      button_to "Delete", destroy_post_path(post)
    end
  end

  def display_flag_if_not_current_user_post(user, post)
    if user != current_user
      button_to "Flag", create_post_flag_path(current_user, post)
    end
  end

  def display_text_field_with_keywords_if_any(post)
    if post.keywords.any?
      keywords_for_field = []
      post.keywords.each do |keyword|
        keywords_for_field << keyword.title
      end
      keywords_for_field = keywords_for_field.join(', ')
      text_field_tag 'keywords', nil, value: keywords_for_field
    else
      text_field_tag 'keywords', nil, placeholder: 'E.g., ruby on rails, agile, web developer, barcelona, brobdingnagian'
    end
  end

  def active_posts_index_category(category)
    divider = 'categories/'
    case category
    when :all_posts
      :active_posts_index_category
    else
      url = request.original_url
      if url.include?(divider)
        url_parts = url.split(divider)
        title = url_parts[1]
        if category == title
          :active_posts_index_category
        end
      end
    end
  end

  def posts_index_category_indication(category)
    divider = 'categories/'
    current_url = request.original_url

    if current_url.include?(divider)
      current_url_parts = current_url.split(divider)
      title = current_url_parts[1]
      if category == title.to_sym
        :active_posts_index_category
      else
        :inactive_posts_index_category
      end
    else
      if category == :all_posts
        :active_posts_index_category
      else
        :inactive_posts_index_category
      end
    end
  end

end
