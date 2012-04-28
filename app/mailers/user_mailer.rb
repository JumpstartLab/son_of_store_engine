class UserMailer < ActionMailer::Base
  default from: "storeengine@gmail.com"
  
  def order_confirmation(user, order)
    @user = user
    @order = order
    mail(:to => user.email,
      :subject => "Your ShoeEngine Order #{order.id}")
  end

  def status_confirmation(user, order)
    @user = user
    @order = order
    mail(:to => @user.email,
      :subject => "Your ShoeEngine Order #{order.id}
      is now #{order.current_status}" )
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
end
