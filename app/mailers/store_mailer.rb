class StoreMailer < ActionMailer::Base
  default from: "info@berrystore.com"

  def store_approval_notification(store_id)
    @store = Store.find(store_id)
    @store_admin = @store.users.first
    mail(:to => "#{@store_admin.name} <#{@store_admin.email}>", :subject => "Your store has been approved")
  end

  def store_declined_notification(store_id)
    @store = Store.find(store_id)
    @store_admin = @store.users.first
    mail(:to => "#{@store_admin.name} <#{@store_admin.email}>", :subject => "Your store has been declined")
  end

  def store_creation_alert(store_id)
    @store = Store.find(store_id)
    @store_admin = @store.users.first
    mail(:to => "#{@store_admin.name} <#{@store_admin.email}>", :subject => "Your store has been created")
  end
end
