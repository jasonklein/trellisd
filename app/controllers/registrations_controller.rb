class RegistrationsController < Devise::RegistrationsController

  def update
    raise
  end
  
  protected

  def after_sign_up_path_for(resource)
    edit_user_path(current_user)
  end

end
