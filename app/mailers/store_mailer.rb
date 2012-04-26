class StoreMailer < ActionMailer::Base
  default from: "info@berrystore.com"

  def store_approval_notification(store)
    @store = store
    @store_admin = @store.users.first
    mail(:to => "#{@store_admin.name} <#{@store_admin.email}>", :subject => "Your store has been approved")
  end

  def store_declined_notification(store)
    @store = store
    @store_admin = @store.users.first
    mail(:to => "#{@store_admin.name} <#{@store_admin.email}>", :subject => "Your store has been declined")
  end

end
