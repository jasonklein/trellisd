class UserMailer < Devise::Mailer
  default from: "trellisdapp@gmail.com"
  default reply_to: "trellisdapp@gmail.com"

  include Devise::Controllers::UrlHelpers

  def reset_password_instructions(record, token, opts={})
    set_inline_trellisd_logo
    super
  end

  def notify_user_of_connection_request(connectee, connecter)
    @connectee = connectee
    @connecter = connecter
    set_inline_trellisd_logo
    mail to: @connectee.email, subject: connecter.name + ' wants to connect on trellisd. Nice!'
  end

  def set_inline_trellisd_logo
    attachments.inline['trellisd_email_image'] = File.read 'app/assets/images/trellisd-logo-100.png'
  end
end
