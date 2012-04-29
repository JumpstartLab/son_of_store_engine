class BackgroundJob
  def self.order_email(user, order)
    Resque.enqueue(OrderEmailer, user.id, order.id, user.class.to_s)
  end

  def self.store_email(store)
    # enqueue store emailer
  end

  def self.promotion_email(permission)
    Resque.enqueue(PromotionEmailer, permission)
  end

  def self.invitation_email(email, privilege, store)
    Resque.enqueue(InvitationEmailer, email, privilege, store)
  end
end