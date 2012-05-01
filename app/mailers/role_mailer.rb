class RoleMailer < ActionMailer::Base
  default from: "info@berrystore.com",
          bcc: "travis.valentine@livingsocial.com"

  def store_stocker_removal_notification(user_id)
    @user = User.find(user_id)
    mail(:to => "#{@user.name} <#{@user.email}>", :subject => "You have been removed as a store stocker")
  end

  def store_admin_removal_notification(user_id)
    @user = User.find(user_id)
    mail(:to => "#{@user.name} <#{@user.email}>", :subject => "You have been removed as a store admin")
  end
end