class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
    data = request.env["omniauth.auth"]
    raise
    identity = Identity.from_omniauth(data)

    if identity
      user = current_user ? current_user : identity.user
      update_identity_user(identity, user)
      flash.notice = "Signed in through Facebook!"
      sign_in_and_redirect user
    else
      flash.notice = "Please sign in with your email or register an account."
      redirect_to new_user_session_path
    end    
  end

  ### If a signed_in_resource is provided it always overrides the existing user
  ### to prevent the identity being locked with accidentally created accounts.

  def update_identity_user(identity, user)
    identity.update_attributes(user_id: user.id) if identity.user != user 
  end
end
