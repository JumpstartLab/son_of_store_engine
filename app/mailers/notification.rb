# Sends out an email
class Notification < ActionMailer::Base
  default :from => "noreply@ehipster.herokuapp.com"

  def order_email(order_id)
    @order =  Order.find_cart(order_id)
    @user  =  @order.user
    mail(:to => @user.email, :subject => "Order Placed - ##{@order.id}")    
  end

  def sign_up_confirmation(email)
     mail(:to => email, :subject => "Congrats on signing up!")
  end
  
  def new_store_emailer(store)
    @store = store
    admin_user = store.users.first
    mail(:to => admin_user.email, :subject => "New Store: #{store.name} is now awaiting approval!")    
  end

  def new_store_approval(store)
    @store = store
    @admin_user = store.users.first
    mail(:to => @admin_user.email, :subject => "New Store: #{store.name} was #{store.status_name}")
  end

  def new_store_request(user)
    mail(:to => user.email, :subject => "New Store Requested")
  end

  def remove_role(email,store)
     mail(:to => email, :subject => "Yo dawg, you've been fired! #{store.name} Doesn't want you anymore") 
  end

  def new_user_and_store_role(email, store, role)
    @email = email
    @store = store
    @role = role
    mail(:to => email, :subject => "You have been invited to become a #{role} of #{store.name}")      
  end

  def new_store_role(email,store,role)
    @store = store
    @role = role
    mail(:to => email, :subject => "You are now a store #{role} of #{store.name}")
  end

end