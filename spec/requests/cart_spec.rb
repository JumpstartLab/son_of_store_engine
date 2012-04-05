require "spec_helper"

describe "Using the shopping cart", :focus => true do
  context "when I'm on the product page" do
    let(:product) { Fabricate(:product) }
    before(:each) do
      visit product_path(product)
    end

    context "I click Add to Cart" do

      before(:each) do
        click_link_or_button "Add to Cart"
      end

      it "takes me to  the cart page!" do
        page.should have_content("Your Cart")
      end

      it "shows me the product in my cart" do
        within("#cart") do
          page.should have_content("#{product.title}")
        end
      end

      it "shows the cart quantity" do
        pending
      end

      it "shows the cart total" do
        pending
      end

    end
  end

end