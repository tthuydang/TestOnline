class ApplicationMailer < ActionMailer::Base
  default from: "from@example.com"
  layout "mailer"

  def feedback_mailer(user)
    @user = user
    mail to: @user.email, subject: "Hello"
  end
end
