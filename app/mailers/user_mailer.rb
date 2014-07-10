class UserMailer < Devise::Mailer
  default from: "trellisdapp@gmail.com"
  default reply_to: "trellisdapp@gmail.com"

  include Devise::Controllers::UrlHelpers
  include AbstractController::Callbacks

  before_filter :set_inline_trellisd_logo

  def reset_password_instructions(record, token, opts={})
    super
  end

  def notify_user_of_connection_request(connection)
    @connectee = connection.connectee
    @connecter = connection.connecter
    mail to: @connectee.email, subject: @connecter.name + ' would like to connect on trellisd. Nice!'
  end

  def notify_user_of_message(message)
    @recipient = message.recipient
    @sender = message.sender
    @subject = message.subject
    @content = message.content
    @message_id = message.id.to_s
    mail to: @recipient.email, subject: 'Your trellisd inbox is getting a workout from ' + @sender.name + '.'
  end

  def notify_user_of_new_matches(user_id, posts_ids)
    @user = User.find(user_id)
    @posts = Post.where(id: posts_ids)
    mail to: @user.email, subject: "You've got some matches."
  end

  def set_inline_trellisd_logo
    attachments.inline['trellisd_email_image.png'] = File.read 'app/assets/images/trellisd-logo-100.png'
  end
end


