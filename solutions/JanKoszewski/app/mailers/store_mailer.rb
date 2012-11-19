# Sends out notification for the store when approved or declined
class StoreMailer < ActionMailer::Base
  include Resque::Mailer
  default :from => "notifications@sonofstoreengine.com"

  def store_accepted_notification(store, email)
    mail(:to => email,
         :subject => 'Your store has been approved')
  end

  def store_declined_notification(store, email)
    mail(:to => email,
         :subject => 'Your store has been declined!')
  end

end
