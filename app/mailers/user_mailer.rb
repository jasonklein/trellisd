class UserMailer < Devise::Mailer
  default from: "trellisdapp@gmail.com"
  default reply_to: "trellisdapp@gmail.com"

  include Devise::Controllers::UrlHelpers

  def reset_password_instructions(record, token, opts={})
    set_inline_trellisd_logo
    super
  end

  def notify_user_of_connection_request(user, connecter)
    @user = user
    attachments.inline['trellisd_email_image'] = File.read 'app/assets/images/trellisd-logo-100.png'
    mail to: @user.email, subject: connecter.name + 'wants to connect!'
  end

  def set_inline_trellisd_logo
    attachments.inline['trellisd_email_image'] = File.read 'app/assets/images/trellisd-logo-100.png'
  end
end
