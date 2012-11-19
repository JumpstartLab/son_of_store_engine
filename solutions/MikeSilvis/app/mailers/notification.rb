# Sends out an email
class Notification < ActionMailer::Base
  default :from => "noreply@ehipster.herokuapp.com"

  # Order Emails
  def order_email(order_id)
    @order =  Order.find_cart(order_id)
    @user  =  @order.user
    mail(:to => @user.email, :subject => "Order Placed - ##{@order.id}")
  end

  # User Emails
  def sign_up_confirmation(email)
     mail(:to => email, :subject => "Congrats on signing up!")
  end

  # Store Emails
  def new_store_approval(store_id)
    @store = Store.find(store_id)
    @admin_user = @store.users.first
    mail(:to => @admin_user.email,
         :subject => "New Store: #{@store.name} was #{@store.status_name}")
  end

  def new_store_request(store_id)
    @store = Store.find(store_id)
    @admin_user = @store.users.first
    mail(:to => @admin_user.email,
         :subject => "New Store: #{@store_name} is now awaiting approval!")
  end

  def remove_role(email,store_id)
     @store = Store.find(store_id)
     mail(:to => email,
          :subject => "Yo dawg, you've been fired!
                       #{@store.name} Doesn't want you anymore")
  end

  def new_user_and_store_role(email, store_id, role)
    @email = email
    @store = Store.find(store_id)
    @role = role
    msg = "You are now a store #{role} of #{@store.name}"
    mail(:to => email, :subject => msg)
  end

  def new_store_role(email,store_id,role)
    @store = Store.find(store_id)
    @role = role
    mail(:to => email,
         :subject => "You are now a store #{role} of #{@store.name}")
  end

end