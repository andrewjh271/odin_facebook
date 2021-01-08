class UserMailer < ApplicationMailer
  def welcome_email
    @user = params[:user]
    mail(to: "#{@user.name} <#{@user.email}>",
         subject: "Welcome to Social Scrolls!, #{@user.name}!")
  end
end
