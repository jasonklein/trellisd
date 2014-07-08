class UserMailer < Devise::Mailer
  default from: "trellisdapp@gmail.com"
  default reply_to: "trellisdapp@gmail.com"

  include Devise::Controllers::UrlHelpers
end
