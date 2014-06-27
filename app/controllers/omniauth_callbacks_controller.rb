class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
    data = request.env["omniauth.auth"]
    identity = Identity.from_omniauth(data)

    if identity
      user = current_user ? current_user : identity.user
      update_identity_user(identity, user)

      access_token = data[:credentials][:token]
      friends_data_request_url = "https://graph.facebook.com/v2.0/#{identity.uid}?fields=friends&access_token=#{access_token}"
      html = HTTParty.get(friends_data_request_url)
      fb_hash = JSON(html)

      if fb_hash.include?("friends")
        friends_array = fb_hash["friends"]["data"]
        friends_uids = friends_array.map { |friend| friend["id"] }
        suggested_connections = []
        friends_uids.each do |uid|
          if identity = Identity.where(uid: uid).first
            SuggestedConnection.where(user_id: user.id, connectee_id: identity.user_id).first_or_create
          end
        end
      end

      flash.notice = "Signed in through Facebook!"
      sign_in_and_redirect user
      
    else
      flash.notice = "Please sign in with your email or register an account before signing in with Facebook."
      redirect_to new_user_session_path
    end    
  end

  ### If a signed_in_resource is provided it always overrides the existing user
  ### to prevent the identity being locked with accidentally created accounts.

  def update_identity_user(identity, user)
    identity.update_attributes(user_id: user.id) if identity.user != user 
  end
end
