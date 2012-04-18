require 'spec_helper'

describe "searching for a product" do
  let(:product) { Fabricate(:product)}
  it "searches for the product" do
    encoded = URI.encode(product.title)
    visit "/search?search%5Bproducts%5D=#{encoded}&commit=Search+for+Products"
    page.should have_content(product.title)
  end
end
