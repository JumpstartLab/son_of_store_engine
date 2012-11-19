class PromotionEmailer
  @queue = :emails

  def self.perform(permission)
    UserMailer.promotion_notice(permission).deliver
  end
end