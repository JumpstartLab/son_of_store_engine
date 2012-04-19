class Search < ActiveRecord::Base
  attr_accessible :products, :orders, :title, :email, :status, :t_sym,
  :total, :d_sym, :date

  def find(params)
    params.each do |key, value|
      params[key] = nil if params[key].blank?
    end
    orders = find_orders_by_date(params[:date], params[:d_sym] || "*") +
    find_orders_by_total(params[:total], params[:t_sym] || "*") +
    find_orders_by_user_email(params[:email]) +
    find_orders_by_status(params[:status])
    orders.uniq!
    find_products(params[:title], orders)
  end

  def find_products(title, orders=Order.all)
    matches = []
    Product.all.each do |product|
      orders.each do |order|
        if order.products.include?(product) &&
          product.title == (title || product.title)
          matches << product
        end
      end
    end
    matches
  end

  def find_orders_by_user_email(email)
    if email
      Order.all.select do |order|
        order.user.email == email
      end
    else
      Order.all
    end
  end

  def find_orders_by_date(date, sym)
    if date
      case sym
      when ">"
        Order.all.select do |order|
          order.created_at > date
        end
      when "<"
        Order.all.select do |order|
          order.created_at < date
        end
      when "="
        Order.all.select do |order|
          order.created_at == date
        end
      end
    else
      Order.all
    end
  end

  def find_orders_by_total(total, sym)
    if total
      case sym
      when ">"
        Order.all.select do |order|
          order.total > total
        end
      when "<"
        Order.all.select do |order|
          order.total < total
        end
      when "="
        Order.all.select do |order|
          order.total == total
        end
      end
    else
      Order.all
    end
  end

  def find_orders_by_status(status)
    if status
      Order.all.select do |order|
        order.status == status
      end
    else
      Order.all
    end    
  end
end
# == Schema Information
#
# Table name: searches
#
#  id         :integer         not null, primary key
#  products   :string(255)
#  orders     :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

