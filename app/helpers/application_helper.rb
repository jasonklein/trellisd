module ApplicationHelper

  def display_session_control_links
    current_uri = request.env['PATH_INFO']
    if current_user
      link_to "Sign Out", destroy_user_session_path, method: :delete, class: "session_control"
    elsif current_uri == new_user_session_path
      link_to "Sign Up", new_user_registration_path, class: "session_control"
    else
      link_to "Sign In", new_user_session_path, class: "session_control"
    end
  end
end
