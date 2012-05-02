# Responsible for all email related to store admins
class StoreAdminMailer < ActionMailer::Base
  include Resque::Mailer
  default :from => "notifications@sonofstoreengine.com"

  def new_admin_email(user, store)
    @user = user
    @store = store
    @url = "http://sonofstoreengine.com"
    mail(:to => user['email'],
         :subject => "You have been made store administrator!")
  end

  def invite_admin_email(email, store)
    @store = store
    @url = "sonofstoreengine.com/users/new"
    mail(:to => email, :subject => "Become a sonofstoreengine user")
  end

  def delete_admin_email(user, store)
    @user = user
    @store = store
    mail(:to => user['email'], :subject => "You have been removed as store admin")
  end
end
