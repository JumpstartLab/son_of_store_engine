class UserMailer < ActionMailer::Base
  include Resque::Mailer
  default from: "thanksforyourmoney@daughterofstoreengine.com"

  def welcome_email(user_id)
    @user = User.find(user_id)
    @url  = "http://daughterofstoreengine.herokuapp.com/"
    mail(:to => @user.email_address, :subject => "Welcome to DOSE!")
  end

  def invite_admin_email(store_permission, email)
    @invite_code = store_permission.admin_hex
    @store_name = store_permission.store.name
    mail(:to => email, :subject => "You have been invited to be an admin of #{@store_name}.")
  end

  def alert_admin_email(store, email)
    @store_name = store.name
    @store_domain = store.domain
    mail(:to => email, :subject => "You have been added as an admin of #{@store_name}.")
  end
end
