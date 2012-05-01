class AdminMailer < ActionMailer::Base
  default from: "confirmation@sonofstoreengine.herokuapp.com"

  def request_admin_signup(email, store_id)
    @store = Store.find(store_id)
    mail(to: email, subject: "Invitation to help run #{@store.name}")
  end

  def new_admin_notification(user_id, store_id, role)
    @role = role
    @user = User.find(user_id.to_i)
    @store = Store.find(store_id)
    mail(to: @user.email, subject: "Invitation to help run #{@store.name}")
  end

  def admin_removal(user_id, store_id, role)
    @role = role
    @user = User.find(user_id.to_i)
    @store = Store.find(store_id)
    mail(to: @user.email, subject: "Your admin privileges for #{@store.name} have been revoked :-(")
  end
end
