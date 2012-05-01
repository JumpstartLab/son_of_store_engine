class Emailer
  @queue = :emails

  def self.perform(mailer, action, *object_ids)
    case mailer
    when "order"
      order_mailer(action, *object_ids)
    when "user"
      user_mailer(action, *object_ids)
    when "admin"
      admin_mailer(action, *object_ids)
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
