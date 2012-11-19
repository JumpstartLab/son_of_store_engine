require 'spec_helper'

describe "store admin for categories", store_admin: true do
  let!(:user) { Fabricate(:user) }
  let!(:store) { Fabricate(:store) }
  let!(:product) { Fabricate(:product, store_id: store) }
  
  before(:each) do
    user.update_attribute(:admin, true)
    user.update_attribute(:admin_view, true)
    visit "/#{store.to_param}/products"
    click_link_or_button "Sign-In"
    login({email: user.email_address, password: user.password})
    visit "/#{store.to_param}/admin/products"
  end
  
  context "category" do
    before(:each) do
      visit "/#{store.to_param}/admin/categories/new"
      fill_in "Name", with: "baseballs"
      click_link_or_button "Create Category"
    end
    
    it "can create a category" do
      current_path.should have_content "baseballs"
    end
    
    it "can edit a category" do
      prod = Fabricate(:product, store_id: store.id)
      prod.categories << Category.last
      visit "/#{store.to_param}/admin/categories"
      click_link_or_button "Edit"
      fill_in "Name", with: "tennis equipment"
      click_link_or_button "Update Category"
      current_path.should == "/#{store.to_param}/admin/categories/#{Category.last.to_param}"
      page.should_not have_content "baseballs"
      page.should have_content "tennis equipment"
    end
    
    it "can delete a category" do
      prod = Fabricate(:product)
      prod.categories << Category.last
      visit "/#{store.to_param}/admin/categories"
      click_link_or_button "Destroy"
      current_path.should == "/#{store.to_param}/admin/categories"
      page.should_not have_content "baseballs"
    end
    
    context "when multiple stores exist" do
      let!(:store_2)    { Fabricate(:store) }
      let!(:category_2) { Fabricate(:category, store_id: store_2.id) }
      
      before(:each) do
        visit "/#{store.to_param}/admin/categories"
      end
      
      it "displays the current store's category", screenshot: true do
        within "#main-content" do
          page.should have_content "baseballs"
        end
      end

      it "does not display categories for other stores" do
        within "#main-content" do
          page.should_not have_content category_2.name
        end
      end
    end
  end
end