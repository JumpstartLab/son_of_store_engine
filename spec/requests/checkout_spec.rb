require 'spec_helper'

describe 'Checkout',:request => :anon do
  context "items in the cart" do
    let!(:products) do
      (1..5).map { FactoryGirl.create(:product) }
    end
    let!(:test_cart) { FactoryGirl.create(:cart, :products => products)}
    before(:each) { load_cart_with_products(products) }

    context "user not logged in" do
      it 'offers checkout as a guest' do
        visit store_cart_path(test_cart.store)
        click_link_or_button "Checkout"
        find_button("Checkout as Guest").visible?.should == true
      end
    end

    it "allows you to enter order information" do
      login(FactoryGirl.create(:user))
      visit store_cart_path(test_cart.store)
      click_link_or_button "Checkout"
      page.current_path.should == new_store_order_path(test_cart.store)
    end
  end

  context "when nothing is in your cart" do
    let!(:test_cart) { FactoryGirl.create(:cart)}

    it "takes you to the root" do
      visit new_store_checkout_path(test_cart.store)
      page.current_path.should == root_path
    end
  end
end