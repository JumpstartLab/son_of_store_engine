class StoreMailer < ActionMailer::Base
  default from: "confirmation@sonofstoreengine.herokuapp.com"

  def store_approval_confirmation(user_id, store_id)
    @user = User.find(user_id)
    @store = Store.find(store_id)
    mail(to: @user.email, subject:"Your store has been approved!")
  end

  def store_rejection_confirmation(user_id, store_id)
    @user = User.find(user_id)
    @store = Store.find(store_id)
    mail(to: @user.email, subject:"Your store has been rejected!")
  end

  def store_creation_confirmation(user_id, store_id)
    @user = User.find(user_id)
    @store = Store.find(store_id)
    mail(to: @user.email, subject:"Your store has been created and is pending approval!")
  end
end
