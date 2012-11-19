# class to deliver emails pertaining to roles
class RoleMailer < ActionMailer::Base
  default from: "info@berrystore.com",
          bcc: "darrell.rivera@livingsocial.com"

  def store_stocker_removal_notification(user_id)
    @user = User.find(user_id)
    mail(:to => "#{@user.name} <#{@user.email}>",
         :subject => "You have been removed as a store stocker")
  end

  def store_admin_removal_notification(user_id)
    @user = User.find(user_id)
    mail(:to => "#{@user.name} <#{@user.email}>",
         :subject => "You have been removed as a store admin")
  end

  def store_admin_addition_notification(user_id)
    @user = User.find(user_id)
    mail(:to => "#{@user.name} <#{@user.email}>",
         :subject => "You have been added as a store admin")
  end

  def store_stocker_addition_notification(user_id)
    @user = User.find(user_id)
    mail(:to => "#{@user.name} <#{@user.email}>",
         :subject => "You have been added as a store stocker")
  end
end