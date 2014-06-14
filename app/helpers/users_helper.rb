module UsersHelper
  def post_user_name(post)
    if post.user != current_user
      connection_id = post.user_id
      connections_hash = @user.all_connections
      if connections_hash[:primary].include? connection_id
        post.user.name
      else
        display = post.user.short_name
        if connections_hash[:secondary].include? connection_id
          display << " (secondary)"
        else
          display << " (tertiary)"
        end
      end
    else
      nil
    end
  end

  def display_category_icon(post)
    category_id = post.category_id
    case category_id
    when 1
      render partial: "icon_partials/activity", locals: {size: "100px"}
    when 2
      render partial: "icon_partials/collab", locals: {size: "100px"}
    when 3
      render partial: "icon_partials/housing", locals: {size: "100px"}
    when 4
      render partial: "icon_partials/knowledge", locals: {size: "100px"}
    when 5
      render partial: "icon_partials/pdq", locals: {size: "100px"}
    when 6
      render partial: "icon_partials/romance", locals: {size: "100px"}
    when 7
      render partial: "icon_partials/stuff", locals: {size: "100px"}
    when 8
      render partial: "icon_partials/travel", locals: {size: "100px"}
    when 9
      render partial: "icon_partials/work", locals: {size: "100px"}
    else
      nil
    end
  end


end
