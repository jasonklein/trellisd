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
    case post.category_id
    when 1
      render partial: 'icon_partials/activity', locals: {size: size}
    when 2
      render partial: 'icon_partials/collab', locals: {size: size}
    when 3
      render partial: 'icon_partials/housing', locals: {size: size}
    when 4
      render partial: 'icon_partials/knowledge', locals: {size: size}
    when 5
      render partial: 'icon_partials/pdq', locals: {size: size}
    when 6
      render partial: 'icon_partials/romance', locals: {size: size}
    when 7
      render partial: 'icon_partials/stuff', locals: {size: size}
    when 8
      render partial: 'icon_partials/travel', locals: {size: size}
    when 9
      render partial: 'icon_partials/work', locals: {size: size}
    else
      nil
    end
  end

  def display_attachment_icon(post)
    render partial: 'icon_partials/paperclip', locals: {size: '60px'} if post.files
  end

  def classname_for_post_box(post)
    matching_ids = current_user.matching_ids_for_all_posts
    matching_ids.include?(post.id) ? 'matching_post' : 'normal'
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

  def display_directionality_if_work_post(post)
    if post.category_id == Category.where(title: 'Work').first.id
      post.directionality.capitalize
    end
  end



end
