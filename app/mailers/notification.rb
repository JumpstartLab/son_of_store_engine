# Sends out an email
class Notification < ActionMailer::Base
  default :from => "noreply@ehipster.herokuapp.com"

  def order_email(user, order)
    Resque.enqueue(NewOrderEmailer, user.id, order.id)
  end

  def sign_up_confirmation(email)
     mail(:to => email, :subject => "Congrats on signing up!")
  end

  def new_store_approval(store)
    Resque.enqueue(NewStoreApprovalEmailer, store.id)
  end

  def new_store_request(store)
    Resque.enqueue(NewStoreRequestEmailer, store.id)
  end

  def new_user_and_store_admin(email, store)
    @email = email
    @store = store
    mail(:to => email, :subject => "You have been invited to become an admin of #{store.name}")    
  end

  def new_store_admin(user, store)
    @store = store
    mail(:to => user.email, :subject => "You are now a store admin of #{store.name}")        
  end

end