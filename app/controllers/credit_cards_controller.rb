class CreditCardsController < ApplicationController

def new
  @credit_card = CreditCard.new
end

def create
  new_credit_card = CreditCard.build_from_stripe_for(current_user, params[:credit_card])
  new_credit_card.save
  redirect_to new_order_path
end

def index
  @credit_cards = current_user.credit_cards
end

end
