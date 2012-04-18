require "spec_helper"

describe "Using the shopping cart", :focus => true do
  context "when I'm on the product page" do
    let(:product) { create_product }
    before(:each) do
      visit product_path(product)
    end

    context "I click Add to Cart" do

      before(:each) do
        click_link_or_button "Add to Cart"
      end

      it "takes me to the cart page!" do
        page.should have_content("Your Cart")
      end

      it "shows me the product in my cart" do
        within("#cart") do
          page.should have_content("#{product.title}")
        end
      end

      it "shows the cart quantity" do
        page.should have_content("1")
      end

      it "adds to same item when pressed again" do
        visit product_path(product)
        click_link_or_button "Add to Cart"
        page.should have_content("2")
      end

    end
    context "Clearing the cart" do
      before(:each) do
        visit cart_path
      end

      it "has a button to clear the cart" do
        page.should have_content("Clear Cart")
      end

      it "clears the cart when pressed" do
        click_link_or_button("Clear Cart")
        within("#cart") do
          within("tbody") do
            page.should_not have_content("#{product.title}")
          end
        end
      end
    end
  end

end