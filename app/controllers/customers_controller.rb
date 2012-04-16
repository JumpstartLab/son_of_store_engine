class CustomersController < ApplicationController
  def create
    customer = Customer.new(params[:customer])
    if customer.save
      render 'orders/create'
    else
      render 'orders/new'
    end
  end
end
