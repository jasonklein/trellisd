class UserMailer < Devise::Mailer
  default from: "trellisdapp@gmail.com"
  default reply_to: "trellisdapp@gmail.com"

  include Devise::Controllers::UrlHelpers

  def reset_password_instructions(record, token, opts={})
    set_inline_trellisd_logo
    super
  end

  def notify_user_of_connection_request(connection)
    @connectee = connection.connectee
    @connecter = connection.connecter
    set_inline_trellisd_logo
    mail to: @connectee.email, subject: @connecter.name + ' wants to connect on trellisd. Nice!'
  end

  def notify_user_of_message(message)
    @recipient = message.recipient
    @sender = message.sender
    @subject = message.subject
    @content = message.content
    @message_id = message.id.to_s
    set_inline_trellisd_logo
    mail to: @recipient.email, subject: 'Your trellisd inbox is getting a workout from ' + @sender.name + '.'
  end

  def set_inline_trellisd_logo
    attachments.inline['trellisd_email_image'] = File.read 'app/assets/images/trellisd-logo-100.png'
  end
end
