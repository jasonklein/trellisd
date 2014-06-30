module PostsHelper

  def post_user_name(post)
    if post.user != current_user
      connection_id = post.user_id
      connections_hash = current_user.all_connections
      if connections_hash[:primary].include? connection_id
        simple_format "#{post.user.name}\n"
      else
        if connections_hash[:secondary].include? connection_id
          simple_format "#{post.user.try(:short_name)} (2°)\n"
        else
          simple_format "#{post.user.try(:short_name)} (3°)\n"
        end
      end
    else
      nil
    end
  end

  def display_post_user_name(user)
    if current_user
      render partial: 'post_user_name', locals: {user: user}
    else
      nil
    end
  end

  def display_category_icon(post, size)
    case post.category.title
    when 'activity'
      render partial: 'icon_partials/activity', locals: {size: size}
    when 'collab'
      render partial: 'icon_partials/collab', locals: {size: size}
    when 'housing'
      render partial: 'icon_partials/housing', locals: {size: size}
    when 'knowledge'
      render partial: 'icon_partials/knowledge', locals: {size: size}
    when 'pdq'
      render partial: 'icon_partials/pdq', locals: {size: size}
    when 'stuff'
      render partial: 'icon_partials/stuff', locals: {size: size}
    when 'travel'
      render partial: 'icon_partials/travel', locals: {size: size}
    when 'work'
      render partial: 'icon_partials/work', locals: {size: size}
    else
      nil
    end
  end

  def display_attachment_icon(post)
    render partial: 'icon_partials/paperclip', locals: {size: '60px'} if post.files
  end

  def classname_for_post_box(post)
    if post.category.try(:title) == 'pdq'
      :pdq_post
    elsif current_user
      matching_ids = current_user.matching_ids_for_all_posts
      matching_ids.include?(post.id) ? :matching_post : :normal_post
    else
      :normal_post
    end
  end

  def classname_for_post_box_if_connected(post)
    if current_user && current_user.all_connections_ids.include?(post.user_id)
      :connection_post
    end
  end

  def displaying_in_posts_controller?
    params[:controller] == 'posts' ? true : false
  end

  def display_keyword_coverage_if_a_match(match)
    render partial: 'posts/keyword_coverage_icon', locals: {keyword_coverage: match.keyword_coverage}
  end

  def show_user_name(user)
    if current_user
      if user!= current_user
        connections_hash = current_user.all_connections
        if connections_hash[:primary].include? user.id
          user.name
        else
          user.short_name
        end
      else
        user.name
      end
    else
      nil
    end
  end

  def display_directionality_if_directionality_cateogry(post)
    if post.directionality_category?
      post.directionality.capitalize
    end
  end

  def display_connection_buttons(user)
    if current_user
      ids = [current_user.id, user.id]
      connection = Connection.where(connecter_id: ids, connectee_id: ids).first
      if connection
        if connection.state == 'accepted'
          render partial: 'connections/disconnect_button', locals: {user: user, label: "Disconnect", connection: connection}
        else
          if connection.connecter_id == current_user.id
            render partial: 'connections/disconnect_button', locals: {user: user, label: "Delete Request", connection: connection}
          else
            render partial: 'connections/accept_reject_buttons', locals: {user: user, label: "Reject", connection: connection}
          end
        end
      else
        if user.id == current_user.id
          nil
        else
          render partial: 'connections/connect_button', locals: {user: user}
        end
      end
    else
      nil
    end
  end

  def display_message_button_if_user_not_current_user(user, post='')
    post_id = post.class.to_s == 'Post' ? post.id : 0
    if current_user
      if user != current_user
        button_to "Message", new_message_path(sender_id: current_user.id, recipient_id: user.id, post_id: post_id), method: :get
      else
        nil
      end
    else
      nil
    end
  end

  def display_flag_button(user)
    button_to "Flag", create_user_flag_path(current_user, user) if current_user && user != current_user
  end

  def posts_with_recent_matches(posts)
    qualifying_posts = []
    posts.each do |post|
      qualifying_posts << post if post.has_recent_matches?
    end
    qualifying_posts.uniq
  end

  def display_posts_with_recent_matches
    if current_user
      posts = posts_with_recent_matches(current_user.posts)
      if posts.any?
        render partial: 'users/notifications_post_listings', locals: {posts: posts}
      end
    else
      nil
    end
  end

  def display_pending_received_connections
    if current_user
      connections = current_user.pending_received_connections
      if connections.any?
        render partial: 'users/notifications_received_connection_listings', locals: {connections: connections}
      end
    else
      nil
    end
  end

  def display_suggested_connections
    if current_user
      suggested_connections = current_user.suggested_connections
      if suggested_connections.any?
        render partial: 'users/notifications_suggested_connection_listings', locals: {suggested_connections: suggested_connections}
      end
    else
      nil
    end
  end

  def display_latest_unviewed_messages
    if current_user
      messages = current_user.unviewed_messages.limit(5)
      if messages.any?
        render partial: 'users/notifications_message_listings', locals: {messages: messages}
      end
    else
      nil
    end
  end

  def display_matches_count_if_current_user_post(post)
    if current_user
      if post.user == current_user
        "Matches: #{post.matches.count}"
      end
    else
      nil
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

  def expiration_class_for_post_box(post)
    days_left = post.expiration - Date.today
    if days_left < 7
      if post.category.try(:title) == 'pdq'
        'impending_expiration_pdq'
      else
        'impending_expiration'
      end
    else
      nil
    end
  end

  def display_edit_if_current_user_post(user, post)
    if current_user
      if user == current_user
        button_to "Edit", edit_post_path(post), method: :get
      end
    else
      nil
    end
  end

  def display_delete_if_current_user_post(user, post)
    if current_user
      if user == current_user
        button_to "Delete", destroy_post_path(post)
      end
    else
      nil
    end
  end

  def display_flag_if_not_current_user_post(user, post)
    if current_user
      if user != current_user
        button_to "Flag", create_post_flag_path(current_user, post)
      end
    else
      nil
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
