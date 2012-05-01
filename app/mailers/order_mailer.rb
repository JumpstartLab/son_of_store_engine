class OrderMailer < ActionMailer::Base
  default from: "info@berrystore.com",
          bcc: "travis.valentine@livingsocial.com"

  def order_confirmation(order)
    @order    = order  
    @user     = order.user  
    @products = order.products  
    mail(:to => @user.email, :subject => "Your Recent Mittenberry Purchase")  
  end
end
