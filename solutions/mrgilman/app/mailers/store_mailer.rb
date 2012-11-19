class StoreMailer < ActionMailer::Base
  include Resque::Mailer
  default from: "thanksforyourmoney@daughterofstoreengine.com"

  def approval_email(store_id)
    @store = Store.find(store_id)
    @email = @store.owner.email_address
    mail(to: @email, subject: "Your store has been approved!")
  end

  def decline_email(store_id)
    @store = Store.find(store_id)
    @email = @store.owner.email_address
    mail(to: @email, subject: "Your store has been declined.")
  end
end
