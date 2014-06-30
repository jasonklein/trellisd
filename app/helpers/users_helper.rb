module UsersHelper
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
      'pdq_post'
    else
      matching_ids = current_user.matching_ids_for_all_posts
      matching_ids.include?(post.id) ? 'matching_post' : 'normal'
    end
  end

  def displaying_in_posts_controller?
    params[:controller] == 'posts' ? true : false
  end

  def display_keyword_coverage_if_a_match(match)
    render partial: 'posts/keyword_coverage_icon', locals: {keyword_coverage: match.keyword_coverage}
  end

  def show_user_name(user)
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
  end

  def display_directionality_if_directionality_cateogry(post)
    if post.directionality_category?
      post.directionality.capitalize
    end
  end

  def display_connection_buttons(user)
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
  end

  def display_message_button_if_user_not_current_user(user, post)
    if user != current_user
      button_to "Message", new_message_path(sender_id: current_user.id, recipient_id: user.id, post_id: post.id), method: :get
    else
      nil
    end
  end

  def display_flag_button(user)
    button_to "Flag", create_user_flag_path(current_user, user) if user != current_user
  end

  def posts_with_recent_matches(posts)
    qualifying_posts = []
    posts.each do |post|
      qualifying_posts << post if post.has_recent_matches?
    end
    qualifying_posts.uniq
  end

  def display_posts_with_recent_matches
    posts = posts_with_recent_matches(current_user.posts)
    if posts.any?
      render partial: 'users/notifications_post_listings', locals: {posts: posts}
    end
  end

  def display_pending_received_connections
    connections = current_user.pending_received_connections
    if connections.any?
      render partial: 'users/notifications_received_connection_listings', locals: {connections: connections}
    end
  end

  def display_suggested_connections
    suggested_connections = current_user.suggested_connections
    if suggested_connections.any?
      render partial: 'users/notifications_suggested_connection_listings', locals: {suggested_connections: suggested_connections}
    end
  end

  def display_latest_unviewed_messages
    messages = current_user.unviewed_messages.limit(5)
    if messages.any?
      render partial: 'users/notifications_message_listings', locals: {messages: messages}
    end
  end







end
