# Sends out an email
class Notification < ActionMailer::Base
  default :from => "noreply@ehipster.herokuapp.com"

  def order_email(user, order)
    Resque.enqueue(NewOrderEmailer, user.id, order.id)
  end

  def sign_up_confirmation(user)
    Resque.enqueue(NewUserEmailer, user.id)
  end

  def new_store_approval(store)
    Resque.enqueue(NewStoreApprovalEmailer, store.id)
  end

  def new_store_request(store)
    Resque.enqueue(NewStoreRequestEmailer, store.id)
  end
end