require 'spec_helper'

describe Category do
  let!(:admin_user) { Fabricate(:admin_user) }
  let!(:store) { Fabricate(:store, :users => [admin_user]) }
  let!(:category) { Fabricate(:category, :store => store) }
  let!(:product)  { Fabricate(:product, :store => store) }

  context "new" do
    it "allows for a product to be added to a category" do

    end
  end

  context "show" do
    it "lists all of the products for that category" do
      category.add_product(product)
      visit category_path(store, category)
      page.should have_content(product.title)
    end
  end

  context "index" do
    it "lists all the categories" do
      visit products_path(store)
      click_link "Browse by Category"
      page.should have_content("#{category.name}")
    end
  end

  context "admin" do
    let(:category) { Fabricate(:category, :store => store) }

    before(:each) do
      login_as(admin_user)
      visit admin_dashboard_path(store)
    end

    it "has a link to browse and edit all categories" do
      page.should have_link("Edit Categories")
    end

    it "and the link takes you to an index of all categories" do
      click_link("Edit Categories")
      current_path.should == admin_categories_path(store)
      page.should have_content(category.name)
    end
    
    context "index" do
      it "has links to edit category" do
        click_link("Edit Categories")
        page.should have_link("Edit")
      end

      it "and the link takes you to an edit category page" do
        click_link("Edit Categories")
        click_link_or_button("Edit")
        current_path.should == edit_admin_category_path(store, category)
        page.should have_selector("form")
      end
    end

    context "edit" do
      
      before(:each) do
        visit edit_admin_category_path(store, category)
      end

      it "displays a form" do
        page.should have_selector("form")
      end

      context "the form" do
        it "asks for a name" do
          within("form") do
            page.should have_content("Name")
            page.should have_selector("input[id$='category_name']")
          end
        end
      end

      it "saves the content when the 'submit' button is pressed" do
        fill_in "category_name", with: "Test Updated Category"
        click_link_or_button "Update Category"
        page.should have_content("Test Updated Category")
      end
    end
  end
end