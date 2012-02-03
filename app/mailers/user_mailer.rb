class UserMailer < ActionMailer::Base
  default from: "notification@bukt.org"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.notice_post.subject
  #
  def notice_post
    @greeting = "Hi"

    mail to: "dan5.ya+bukt@gmail.com"
  end
end
