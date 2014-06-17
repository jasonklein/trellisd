class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :get_all_connections_for_current_user

  # Set the layout for the Devise Sessions Controller

  layout :layout_by_resource

  def layout_by_resource
    if devise_controller? && resource_name == :user && action_name == 'new'
      'layout_for_sessions_controller'
    else
      'application'
    end
  end

  rescue_from CanCan::AccessDenied do |exception|
    if current_user
      redirect_to user_home_path, notice: 'Sorry, you cannot see this page.'
    else
      redirect_to new_user_session_path
    end
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    if current_user
      redirect_to user_home_path(current_user), notice: 'Whoops, that record does not seem to exist!'
    else
      redirect_to new_user_session_path(current_user), notice: 'You must be signed in to access this.'
    end
  end

  protected
  def after_sign_in_path_for(resource)
    user_home_path(current_user)
  end

  private
  def get_all_connections_for_current_user
    if current_user
      @all_connections = current_user.all_connections
    end
  end

end
