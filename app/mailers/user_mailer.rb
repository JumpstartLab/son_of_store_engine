class UserMailer < ActionMailer::Base
  include Resque::Mailer
  default from: "thanksforyourmoney@daughterofstoreengine.com"

  def welcome_email(user_id)
    @user = User.find(user_id)
    @url  = "http://daughterofstoreengine.herokuapp.com/"
    mail(:to => @user.email_address, :subject => "Welcome to DOSE!")
  end

  def invite_admin_email(store_id, admin_hex, email)
    @invite_code = admin_hex
    store_name = Store.find(store_id).name
    mail(:to => email, :subject => "You have been invited to be an admin of #{store_name}.")
  end


  def alert_admin_email
  end

  def invite_stocker_email(store_id, admin_hex, email)
    @invite_code = admin_hex
    store_name = Store.find(store_id).name
    mail(:to => email, :subject => "You have been invited to be a stocker of #{store_name}.")
  end

  def alert_stocker_email(store_id, email)
    @store = Store.find(store_id)
    mail(:to => email, :subject => "You have been added as a stocker of #{@store.name}.")
  end

  def fire_admin(store_id, email)
    store_name = Store.find(store_id).name
    mail(:to => email, :subject => "You have been fired from your admin position at #{store_name}.")
  end

  def fire_stocker(store_id, email)
    store_name = Store.find(store_id).name
    mail(:to => email, :subject => "You have been fired from your stocker position at #{store_name}.")
  end
end
