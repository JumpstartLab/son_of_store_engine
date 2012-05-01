class CreditCardsController < ApplicationController

  def new
    @credit_card = CreditCard.new
  end

  def create
    @cc = current_user.credit_cards.new
    @cc.stripe_card_token = params[:credit_card][:stripe_card_token]
    @cc.save
    redirect_to new_order_path
  end

  def index
    @credit_cards = current_user.credit_cards
  end

end
