class AdminMailer < ActionMailer::Base
  default from: "confirmation@sonofstoreengine.herokuapp.com"

  def request_admin_signup(email, store_id)
    @store = Store.find(store_id)
    mail(to: email, subject: "Invitation to help run #{@store.name}")
  end

  def new_admin_notification(email, store_id)
    @store = Store.find(store_id)
    mail(to: email, subject: "Invitation to help run #{@store.name}")
  end
end