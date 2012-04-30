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

  def self.admin_mailer(action, arg1, arg2)
    case action
    when "request_signup"
      AdminMailer.request_admin_signup(arg1, arg2).deliver
    when "new_admin_notification"
      AdminMailer.new_admin_notification(arg1, arg2).deliver
    when "admin_removal"
      user = User.find(arg1.to_i)
      AdminMailer.admin_removal(user.email, arg2).deliver
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