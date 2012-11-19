# Sends out notification for the store when approved or declined
class Notification < ActionMailer::Base
  default from: "from@example.com"

  def store_accepted_notification(store)
    mail(:to => store.users.first.email,
         :subject => 'Your store has been approved')
  end

  def store_declined_notification(store)
    mail(:to => store.users.first.email,
         :subject => 'Your store has been declined!')
  end

end
