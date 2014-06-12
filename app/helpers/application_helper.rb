module ApplicationHelper

  def display_session_control_links
    if current_user
      link_to "Sign Out", destroy_user_session_path, method: :delete
    else
      nil
    end
  end
end
