class UserMailer < ApplicationMailer
  def welcome_email
    @user = params[:user]
    mail(to: "#{@user.name} <#{@user.email}>",
         subject: "Welcome to Social Scrolls!, #{@user.name}!")
  end

  def odin_update
    @ip = params[:ip]
    @address = Geocoder.address(@ip)
    mail(to: 'Andrew Hayhurst <hayhurst.andrew@gmail.com>',
         subject: 'Someone has attempted to update Odin\'s account')
  end

  def odin_delete
    @ip = params[:ip]
    @address = Geocoder.address(@ip)
    mail(to: 'Andrew Hayhurst <hayhurst.andrew@gmail.com>',
         subject: 'Someone has attempted to delete Odin\'s account')
  end
end
