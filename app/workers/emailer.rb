class Emailer
  @queue = :emails

  def self.perform(mailer, action, *args)
    case mailer
    when "order"
      order_mailer(action, *args)
    when "user"
      user_mailer(action, *args)
    when "admin"
      admin_mailer(action, *args)
    when "store"
      store_mailer(action, *args)
    end
  end

  def self.admin_mailer(action, user_id_or_email, store_id, role="stocker")
    case action
    when "request_signup"
      AdminMailer.request_admin_signup(user_id_or_email, store_id).deliver
    when "new_admin_notification"
      AdminMailer.new_admin_notification(user_id_or_email, store_id, role).deliver
    when "admin_removal"
      AdminMailer.admin_removal(user_id_or_email, store_id, role).deliver
    end
  end

  def self.store_mailer(action, user_id, store_id)
    case action
    when "store_creation_confirmation"
      StoreMailer.store_creation_confirmation(user_id, store_id).deliver
    when "store_approval_confirmation"
      StoreMailer.store_approval_confirmation(user_id, store_id).deliver
    when "store_rejection_confirmation"
      StoreMailer.store_rejection_confirmation(user_id, store_id).deliver
    end
  end

  def self.order_mailer(action, order_id)
    order = Order.scoped.where("id = #{order_id}")
    case action
    when "confirmation"
      OrderMailer.order_confirmation(order).deliver
    end
  end

  def self.user_mailer(action, user_id)
    user = User.scoped.where("id = #{user_id}")
    case action
    when "signup"
      UserMailer.signup_confirmation(user.first).deliver
    end
  end
end
