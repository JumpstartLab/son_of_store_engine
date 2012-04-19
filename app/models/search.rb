class Search < ActiveRecord::Base
  attr_accessible :products, :orders, :title, :email, :status, :t_sym,
  :total, :d_sym, :date

  def find(params)
    params.each do |key, value|
      params[key] = nil if params[key].blank?
    end
    orders = find_orders_by_date(params[:date], params[:d_sym] || "*") &
    find_orders_by_total(params[:total], params[:t_sym] || "*") &
    find_orders_by_user_email(params[:email]) &
    find_orders_by_status(params[:status])
    find_orders_by_products(params[:title], orders)
  end

  def find_orders_by_products(title, orders)
    if title
      products = Product.find_all_by_title(title)

      p_orders = products.inject([]) do |sum,product|
        sum << product.orders
      end
      p_orders.flatten.uniq & orders
    else
      orders
    end
  end

  def find_orders_by_user_email(s_email)
    if s_email
      Order.all.select do |order|
        order.user.email == s_email
      end
    else
      Order.all
    end
  end

  def find_orders_by_date(s_date, sym)
    if s_date
      case sym
      when ">"
        Order.all.select do |order|
          order.created_at > s_date
        end
      when "<"
        Order.all.select do |order|
          order.created_at < s_date
        end
      when "="
        Order.all.select do |order|
          order.created_at == s_date
        end
      end
    else
      Order.all
    end
  end

  def find_orders_by_total(s_total, sym)
    if s_total
      s_total = s_total.to_i
      find_total(s_total,sym)
    else
      Order.all
    end
  end

  def find_total(s_total,sym)
    case t_sym
    when ">"
      Order.all.select do |order|
        order.total > s_total
      end
    when "<"
      Order.all.select do |order|
        order.total < s_total
      end
    when "="
      Order.all.select do |order|
        order.total == s_total
      end
    end
  end

  def find_orders_by_status(status)
    if status
      Order.all.select do |order|
        order.status.downcase == status.downcase
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

