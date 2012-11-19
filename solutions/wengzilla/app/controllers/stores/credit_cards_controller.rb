# module for the store_slug namespage
module Stores
  # to handle stripe in each store
  class CreditCardsController < ApplicationController
    def new
      @credit_card = CreditCard.new
    end

    def create
      # new_credit_card = CreditCard.build_from_stripe_for(current_user, params[:credit_card])
      new_credit_card = current_user.credit_cards.create(last_four: params[:number],
                                                          exp_month: params[:month],
                                                          exp_year: params[:year])
      redirect_to new_store_order_path
    end

    def index
      @credit_cards = current_user.credit_cards
    end
  end
end