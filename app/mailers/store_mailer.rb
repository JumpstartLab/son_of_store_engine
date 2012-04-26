class StoreMailer < ActionMailer::Base
  include Resque::Mailer
  default from: "thanksforyourmoney@daughterofstoreengine.com"

  def approval_email(store)
    @store = store
    @email = store.owner.email_address
    mail(to: @email, subject: "Your store has been approved!")
  end

  def decline_email(store)
    @store = store
    @email = store.owner.email_address
    mail(to: @email, subject: "Your store has been declined.")
  end
end
