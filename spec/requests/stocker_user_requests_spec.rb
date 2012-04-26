require 'spec_helper'

describe User do
  msg = "Store Stocker works with products like a store admin
         https://www.pivotaltracker.com/story/show/28489033"
  pending msg do
    context "with role stocker can" do
      it "view a store's products at the stocker url"

      context "create products" do
        it "for the associated store"
        it "and after creation view a list of products with a confirmation"
      end

      context "edit products" do
        it "for the associated store"
        it "and after editing view a list of products with a confirmation"
      end

      context "retire products" do
        it "for the associated store"
        it "and after retiring view a list of products with a confirmation"
      end
    end
  end
end
