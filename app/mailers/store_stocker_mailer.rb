# Responsible for all email related to store admins
class StoreStockerMailer < ActionMailer::Base
  default from: "from@example.com"

  def new_stocker_email(user, store)
    @user = user
    @store = store
    @url = "http://sonofstoreengine.com"
    mail(:to => user.email,
         :subject => "You have been made store stocker!")
  end

  def invite_stocker_email(email, store)
    @store = store
    @url = "sonofstoreengine.com/users/new"
    mail(:to => email, :subject => "Become a sonofstoreengine user")
  end

  def delete_stocker_email(user, store)
    @user = user
    @store = store
    mail(:to => user.email, :subject =>
      "You have been removed as store stocker")
  end
end
