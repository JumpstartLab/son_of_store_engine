require 'spec_helper'

describe "store owner actions", dose_store_admin: true do
  let!(:store_owner)    { Fabricate(:user) }
  let!(:store)          { Fabricate(:store, creating_user_id: store_owner) }

  context "when authenticated" do
    before(:each) do
      visit "/"
      click_link_or_button "Sign-In"
      login({email: store_owner.email_address, password: store_owner.password})
    end

    context "when on the store administration page" do
      before(:each) do
        visit admin_store_path(store)
      end

      it "displays the name" do
        find("#store_name").text.should have_content store.name
      end

      it "displays the domain" do
        find("#store_domain").text.should have_content store.domain
      end

      it "displays the description" do
        find("#store_description").text.should have_content store.description
      end

      it "displays the edit button" do
        page.should have_content "Edit"
      end

      context "when the store is pending approval" do
        before(:each) do
          store.update_attribute(:approval_status, "pending")
          store.update_attribute(:enabled, false)
          visit admin_store_path(store)
        end

        it "displays a pending approval status" do
          find("#store_approval_status").text.downcase.should have_content "pending"
        end

        it "shows the site as disabled" do
          find("#store_active_status").text.downcase.should have_content "disabled"
        end

        context "for available store admin actions" do
          it "does not allow the site to be enabled" do
            page.should_not have_selector "#enable_toggle"
          end
        end
      end

      context "when the store was approved" do
        before(:each) do
          store.update_attribute(:approval_status, "approved")
        end

        it "displays that the site is approved" do
          find("#store_approval_status").text.downcase.should have_content "approved"
        end

        context "the store active state is disabled" do
          before(:each) do
            store.update_attribute(:enabled, false)
            visit admin_store_path(store)
          end

          it "shows the site as disabled" do
            find("#store_active_status").text.downcase.should have_content "disabled"
          end

          context "for available store admin actions" do
            it "allows the site to be enabled" do
              page.should have_selector "#enable_toggle"
            end

            context "after activating the store" do
              before(:each) do
                find("#enable_toggle").click
              end

              it "notifies the the user that the site is now enabled" do
                page.should have_content "#{store.name} has been enabled."
              end

              it "shows the site as enabled" do
                within "#store_#{store.id}"do
                  page.should have_content "Yes"
                end
              end
            end
          end
        end

        context "the store active state is enabled" do
          before(:each) do
            store.update_attribute(:enabled, true)
            visit admin_store_path(store)
          end

          it "shows the site as enabled" do
            find("#store_active_status").text.downcase.should have_content "enabled"
          end

          context "for available store admin actions" do
            it "allows the site to be disabled" do
              page.should have_selector "#enable_toggle"
            end

            context "after activating the store" do
              before(:each) do
                find("#enable_toggle").click
              end

              it "notifies the the user that the site is now disabled" do
                page.should have_content "#{store.name} has been disabled."
              end

              it "shows the site as enabled" do
                within ("#store_#{store.id}")do
                  page.should have_content "No"
                end
              end
            end
          end
        end
      end

      context "when the store was declined" do
        before(:each) do
          store.update_attribute(:approval_status, "declined")
          store.update_attribute(:enabled, false)
          visit admin_store_path(store)
        end

        it "displays a pending approval status" do
          find("#store_approval_status").text.downcase.should have_content "declined"
        end

        it "shows the site as disabled" do
          find("#store_active_status").text.downcase.should have_content "disabled"
        end

        context "for available store admin actions" do
          it "does not allow the site to be enabled" do
            page.should_not have_selector "#enable_toggle"
          end
        end
      end
      context "editing the store" do
        before(:each) do
          click_link_or_button "Edit"
        end
        it "can edit the store name" do
          old_name = store.name
          fill_in :name, with: "A different name"
          click_link_or_button "Update Store"
          current_path.should == admin_store_path(store)
          page.should have_content "A different name"
          page.should_not have_content old_name
          page.should have_content "updated successfully"
        end
        it "can edit the store domain" do
          old_domain = store.domain
          fill_in "Domain", with: "different-store"
          click_link_or_button "Update Store"
          current_path.should == admin_store_path(Store.find_by_domain("different-store"))
          within "#store_domain" do
            page.should have_content "different-store"
            page.should_not have_content old_domain
          end
          page.should have_content "updated successfully"
        end
      end
    end
  end

  context "adding another store admin" do
    context "the added user already has an account" do
      let!(:new_admin) { Fabricate(:user) }
      before(:all) do
        visit "/"
        click_link_or_button "Sign-In"
        login({email: store_owner.email_address, password: store_owner.password})
        visit admin_store_path(store)
        fill_in("store_permission_email", with: new_admin.email_address)
      end
      it "creates a new Store Permissions record" do
        expect { click_link_or_button "Add New Store Admin" }.to change { StorePermission.count }.by(1)
      end
  #     it "displays the new admin on the store admin page" do
  #       within("#admin_list") do
  #         page.should have_content(new_admin.email_address)
  #         page.should have_content(new_admin.name)
  #       end
  #     end
  #   end
  #   context "the added user does not already have an account" do
  #
    end
  end
end
