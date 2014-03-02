class UserMailer < ActionMailer::Base
  default from: "admin@onlynet.biz"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.notice.subject
  #
  def notice
    @greeting = "Hi"
    mail to: "jason@eatgo.com"
  end
end
