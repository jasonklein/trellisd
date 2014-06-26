class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
    data = request.env["omniauth.auth"]
    user = User.determined_through_omniauth(data, current_user)

    if user.persisted?
      flash.notice = "Signed in through Facebook!"
      sign_in_and_redirect user
    else
      session["devise.user_attributes"] = user.attributes
      flash.notice = "Problem creating account."
      redirect_to new_user_registration_url
    end    
  end
end
