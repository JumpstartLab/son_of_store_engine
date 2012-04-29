class StoreMailer < ActionMailer::Base
  default from: "confirmation@sonofstoreengine.herokuapp.com"

  def store_approval_confirmation(user, store)
    @user = User.find_by_id(store.owner_id)
    @store = store
    mail(to: @user.email, subject:"Your store has been approved!")
  end
end
