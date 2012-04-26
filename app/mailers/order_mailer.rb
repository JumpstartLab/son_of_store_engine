class OrderMailer < ActionMailer::Base
  default from: "info@mittenberry.com"

  def order_confirmation(order)
    @order    = order  
    @user     = order.user  
    @products = order.products  
    mail(:to => "#{@user.name} #{@user.email}", :subject => "Your Recent Mittenberry Purchase")  
  end

end