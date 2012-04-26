# Sends out an email
class Notification < ActionMailer::Base
  default :from => "noreply@ehipster.herokuapp.com"

  def order_email(user, order)
    @user = user
    @order = order
    mail(:to => user.email, :subject => "Order Placed - ##{order.id}")
  end

  def sign_up_confirmation(user)
    @user = user
    mail(:to => user.email, :subject => "Welcome #{user.name}")
  end

  def new_store_approval(store)
    @store = store
    @admin_user = store.users.first
    mail(:to => @admin_user.email, :subject => "New Store: #{store.name} was #{store.status}")
  end

  def new_store_request(store)
    @store = store
    @admin_user = store.users.first
    mail(:to => @admin_user.email, :subject => "New Store Requested")
  end
end