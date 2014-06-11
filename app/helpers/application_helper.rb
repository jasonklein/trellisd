module ApplicationHelper

  def display_session_control_links
    current_uri = request.env['PATH_INFO']
    if current_user
      link_to "Sign Out", destroy_user_session_path, method: :delete
    elsif current_uri != new_user_session_path
      link_to "Sign In or Sign Up", new_user_session_path
    end
  end
end
