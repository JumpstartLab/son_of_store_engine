class Emailer
  @queue = :emails

  def self.perform(mailer, action, object)
    case mailer
    when "order"
      order_mailer(action, object)
    when "user"
      user_mailer(action, object)
    end
  end

  def self.order_mailer(action, order)
    case action
    when "confirmation"
      OrderMailer.order_confirmation(order).deliver
    end
  end

    def self.user_mailer(action, user)
    case action
    when "signup"
      UserMailer.signup_confirmation(user).deliver
    end
  end
end