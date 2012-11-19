require 'spec_helper'

describe "Store Admin Permissions" do
  let!(:store_owner)          { Fabricate(:user) }
  let!(:store_stocker)        { Fabricate(:user) }
  let!(:other_store_owner)    { Fabricate(:user) }
  let!(:store)                { Fabricate(:store, creating_user_id: store_owner.id) }
  let!(:some_other_store)     { Fabricate(:store, creating_user_id: other_store_owner.id) }
  let!(:store_product)        { Fabricate(:product, store_id: store.id) }
  let!(:store_category)       { Fabricate(:category, store_id: store.id) }
  let!(:stock_permission)     { Fabricate(:store_stocker_permission, store_id: store.id, user_id: store_stocker.id) }

  describe "accessing store admin dashboard" do
    context "the user is the store owner" do
      before(:each) do
        visit root_path
        click_link_or_button "Sign-In"
        login(email: store_owner.email_address, password: store_owner.password)
      end

      it "allows the user to access the page" do
        visit "/#{store.to_param}/admin"
        current_path.should == "/#{store.to_param}/admin"
        page.should have_content "Store Settings"
      end
    end

    context "the user is a stocker for this store" do
      before(:each) do
        visit root_path
        click_link_or_button "Sign-In"
        login(email: store_stocker.email_address, password: store_stocker.password)
      end

      it "doesn't allow the user to access the page" do
        visit "/#{store.to_param}/admin"
        current_path.should == root_path
        page.should_not have_content "Store Settings"
      end
    end

    context "the user is not an admin for this store" do
      before(:each) do
        visit root_path
        click_link_or_button "Sign-In"
        login(email: other_store_owner.email_address, password: other_store_owner.password)
      end

      it "doesn't allow the user to access the page" do
        visit "/#{store.to_param}/admin"
        current_path.should == root_path
        page.should_not have_content "Store Settings"
      end
    end
  end

  describe "accessing store admin products page" do
    context "the user is the store owner" do
      before(:each) do
        visit root_path
        click_link_or_button "Sign-In"
        login(email: store_owner.email_address, password: store_owner.password)
      end

      it "allows the user to access the page" do
        visit "/#{store.to_param}/admin/products"
        current_path.should == "/#{store.to_param}/admin/products"
        page.should have_selector "#admin_product_#{store_product.id}"
      end
    end

    context "the user is a stocker for this store" do
      before(:each) do
        visit root_path
        click_link_or_button "Sign-In"
        login(email: store_stocker.email_address, password: store_stocker.password)
      end

      it "allows the user to access the page" do
        visit "/#{store.to_param}/admin/products"
        current_path.should == "/#{store.to_param}/admin/products"
        page.should have_selector "#admin_product_#{store_product.id}"
      end
    end

    context "the user is not an admin for this store" do
      before(:each) do
        visit root_path
        click_link_or_button "Sign-In"
        login(email: other_store_owner.email_address, password: other_store_owner.password)
      end

      it "doesn't allow the user to access the page" do
        visit "/#{store.to_param}/admin/products"
        current_path.should == root_path
        page.should_not have_selector "#admin_product_#{store_product.id}"
      end
    end
  end

  describe "accessing store admin categories page" do
    context "the user is the store owner" do
      before(:each) do
        visit root_path
        click_link_or_button "Sign-In"
        login(email: store_owner.email_address, password: store_owner.password)
      end

      it "allows the user to access the page" do
        visit "/#{store.to_param}/admin/categories"
        current_path.should == "/#{store.to_param}/admin/categories"
        page.should have_selector "#admin_category_#{store_category.id}"
      end
    end

    context "the user is a stocker for this store" do
      before(:each) do
        visit root_path
        click_link_or_button "Sign-In"
        login(email: store_stocker.email_address, password: store_stocker.password)
      end

      it "doesn't allow the user to access the page" do
        visit "/#{store.to_param}/admin/categories"
        current_path.should == root_path
        page.should_not have_selector "#admin_category_#{store_category.id}"
      end
    end

    context "the user is not an admin for this store" do
      before(:each) do
        visit root_path
        click_link_or_button "Sign-In"
        login(email: other_store_owner.email_address, password: other_store_owner.password)
      end

      it "doesn't allow the user to access the page" do
        visit "/#{store.to_param}/admin/categories"
        current_path.should == root_path
        page.should_not have_selector "#admin_category_#{store_category.id}"
      end
    end
  end

  describe "accessing store admin orders page" do
    context "the user is the store owner" do
      before(:each) do
        visit root_path
        click_link_or_button "Sign-In"
        login(email: store_owner.email_address, password: store_owner.password)
      end

      it "allows the user to access the page" do
        visit "/#{store.to_param}/admin/orders"
        current_path.should == "/#{store.to_param}/admin/orders"
        page.should have_content "No Orders Match Your Criteria"
      end
    end

    context "the user is a stocker for this store" do
      before(:each) do
        visit root_path
        click_link_or_button "Sign-In"
        login(email: store_stocker.email_address, password: store_stocker.password)
      end

      it "doesn't allow the user to access the page" do
        visit "/#{store.to_param}/admin/orders"
        current_path.should == root_path
        page.should_not have_content "No Orders Match Your Criteria"
      end
    end

    context "the user is not an admin for this store" do
      before(:each) do
        visit root_path
        click_link_or_button "Sign-In"
        login(email: other_store_owner.email_address, password: other_store_owner.password)
      end

      it "doesn't allow the user to access the page" do
        visit "/#{store.to_param}/admin/orders"
        current_path.should == root_path
        page.should_not have_content "No Orders Match Your Criteria"
      end
    end
  end

  describe "signing up after recieving an admin invite" do
    let!(:store) { Fabricate(:store) }
    let!(:store_permission) { Fabricate(:store_permission, user_id: nil, admin_hex: "12345", store_id: store.id, permission_level: 1)}
    before(:each) do
      visit '/users/new?invite_code=12345'
      sign_up({full_name: "Test User", email: "frank@zappa.com", password: "test", display_name: "Test"})
    end

    it "creates a new user" do
      User.last.display_name.should == "Test"
    end

    it "assigns the user's id to the store_permission record" do
      StorePermission.last.user_id.should == User.last.id
    end

    it "gives the user admin rights" do
      StorePermission.last.permission_level.should == 1
    end
  end

  describe "signing up after recieving an stocker invite" do
    let!(:store) { Fabricate(:store) }
    let!(:store_permission) { Fabricate(:store_permission, user_id: nil, admin_hex: "12345", store_id: store.id, permission_level: 2)}
    before(:each) do
      visit '/users/new?invite_code=12345'
      sign_up({full_name: "Test User", email: "frank@zappa.com", password: "test", display_name: "Test"})
    end

    it "creates a new user" do
      User.last.display_name.should == "Test"
    end

    it "assigns the user's id to the store_permission record" do
      StorePermission.last.user_id.should == User.last.id
    end

    it "gives the user stocker rights" do
      StorePermission.last.permission_level.should == 2
    end
  end
end


