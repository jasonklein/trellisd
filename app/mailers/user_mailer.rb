class UserMailer < Devise::Mailer
  default from: "trellisdapp@gmail.com"
  default reply_to: "trellisdapp@gmail.com"

  include Devise::Controllers::UrlHelpers

  def reset_password_instructions(record, token, opts={})
    attachments.inline['trellisd_email_image'] = File.read 'app/assets/images/trellisd-logo-100.png'
    super
  end
end
