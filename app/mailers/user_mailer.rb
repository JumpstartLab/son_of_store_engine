class UserMailer < ActionMailer::Base
  default from: "storeengine@gmail.com"
  
  def order_confirmation(user, order)
    @user = user
    @order = order
    mail(:to => @user.email,
      :subject => "Your #{order.store.name} Order #{order.id}")
  end

  def status_confirmation(user, order)
    @user = user
    @order = order
    mail(:to => @user.email,
      :subject => "Your #{order.store.name} Order #{order.id} is now #{order.current_status}" )
  end

  def declined_store_notice(store)
    @user = store.owner
    @store = store
    mail(:to => @user.email,
      :subject => "Your Store Proposal for #{store.name} has been declined" )
  end

  def approved_store_notice(store)
    @user = store.owner
    @store = store
    mail(:to => @user.email,
      :subject => "Your Store Proposal for #{store.name} has been approved" )
  end

  def promotion_notice(permission)
    @user = User.find(permission["user_id"])
    @store = Store.find(permission["store_id"])
    @role = permission["name"]
    mail(:to => @user.email,
      :subject => "Your new job, should you choose to accept it is #{@role}." )
  end

  def invitation(email, privilege, store)
    @email = email
    @privilege = privilege
    @store_name = Store.find_by_id(store["id"]).name
    mail(:to => @email,
      :subject => "#{@store_name} wants you to sign up so you can be a #{@privilege}!" )
  end
end
