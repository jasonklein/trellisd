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

  def display_category_icon(post)
    category_id = post.category_id
    case category_id
    when 1
      render partial: "icon_partials/activity", locals: {size: "60px"}
    when 2
      render partial: "icon_partials/collab", locals: {size: "60px"}
    when 3
      render partial: "icon_partials/housing", locals: {size: "60px"}
    when 4
      render partial: "icon_partials/knowledge", locals: {size: "60px"}
    when 5
      render partial: "icon_partials/pdq", locals: {size: "60px"}
    when 6
      render partial: "icon_partials/romance", locals: {size: "60px"}
    when 7
      render partial: "icon_partials/stuff", locals: {size: "60px"}
    when 8
      render partial: "icon_partials/travel", locals: {size: "60px"}
    when 9
      render partial: "icon_partials/work", locals: {size: "60px"}
    else
      nil
    end
  end

  def display_attachment_icon(post)
    render partial: "icon_partials/paperclip", locals: {size: "60px"} if post.files
  end

  def classname_for_post_box(post)
    matching_ids = current_user.matching_ids_for_all_posts
    matching_ids.include?(post.id) ? "matching_post" : "normal"
  end

  # def display_keyword_coverage_if_matching_post(classname, post, matching_id)
  #   if classname == "matching_post"
  #     render partial: "users/keyword_coverage_icon", locals: {post_id: post.id, matching_id: matching_id}
  #   end
  # end


end
