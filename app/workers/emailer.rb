class Emailer
  @queue = :emails

  def self.perform(mailer, action, object_id)
    case mailer
    when "order"
      order_mailer(action, object_id)
    when "user"
      user_mailer(action, object_id)
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