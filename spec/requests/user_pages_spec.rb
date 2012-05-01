require 'spec_helper'

describe "User pages" do
  let(:user) { FactoryGirl.create(:user) }
  let!(:store) { FactoryGirl.create(:store, :owner_id => user.id) }

  describe "signin page" do
    before { visit signin_path }

    it "has a registration link" do
      page.should have_content("Register")
    end
  end

  describe "signup page" do
    before { visit signup_path }

    # it { should have_field('user_email', :type => 'text') }

    describe "when I click create my account" do
      describe "when the form is empty" do
        it "does not register a user" do
          expect { click_button "Create Account" }.not_to change(User, :count)
        end
      end

      describe "when I have valid user details" do
        pending "Need to fix orders_controller def create as per todo"
        before do
          fill_in "user_name",         with: "Example User"
          fill_in "user_email",        with: "user@example.com"
          fill_in "user_password",     with: "foobar"
          fill_in "user_password_confirmation", with: "foobar"
        end

        # it "should create a user" do
        #   expect { click_button "Create Account" }.to change(User, :count).by(1)
        # end
      end
    end
  end

  context "when not signed in" do
    before { visit root_path }

    it "has a sign up link" do
      page.should have_content('Register')
    end

    it "sends me to the appropriate top-level page when the sign up link is clicked" do
      pending "JQ TODO: Check with Matt on if this can be /signup or if he really wants /users/new"
      click_link_or_button('Register')
      page.should have_selector('#registration_page')
    end

    context "creating a new user" do
      before(:each) do
        click_link_or_button('Register')
        @user_name = Faker::Name.name
        @user_email = Faker::Internet.email
        @user_display_name = Faker::Internet.user_name
      end

      describe "when I enter my email address, full name, and display name and click create" do
        before(:each) do
          fill_in "email", with: @user_email
          fill_in "name", with: @user_name
          fill_in "display_name", with: @user_display_name
          fill_in "password", with: "foobar"
          fill_in "password_confirmation", with: "foobar"
          click_link_or_button('Create Account')
        end

        it "sends me to the page I was on" do
          pending "TODO: Look into how to test what page was on/what page getting sent to. Feature is imp'd -JQ"
        end

        it "shows a flash message" do
          page.should have_selector("#alert")
        end

        it "confirms account creation with the flash message" do
          page.should have_content("Sign-up complete! You're now logged in!")
        end

        it "includes a link to view the new profile" do
          page.should have_content("My Profile")
        end

        it "sends an email confirmation" do
          pending "This is handled via the queue. Change the test to match"
          # ActionMailer::Base.deliveries.last.to.should == [@user_email]
          # ActionMailer::Base.deliveries.last.subject.should == "Welcome to Store Engine!"
        end
      end

      describe "visitor omits full name" do
        before(:each) do
          fill_in "email", with: @user_email
          fill_in "display_name", with: @user_display_name
          fill_in "password", with: "foobar"
          fill_in "password_confirmation", with: "foobar"
          click_link_or_button('Create Account')
        end

        it "should still be on the 'create user' page" do
          page.should have_selector("#registration_page")
        end

        it "should tell me that Name cannot be blank" do
          page.should have_content("Name can't be blank")
        end

        it "should allow me to correct the missing name and resubmit" do
          fill_in "name", with: @user_name
          fill_in "password", with: "foobar"
          fill_in "password_confirmation", with: "foobar"
          click_link_or_button('Create Account')
          page.should have_content("Sign-up complete! You're now logged in!")
        end

      end

      describe "visitor uses duplicate email address" do
        before(:each) do
          FactoryGirl.create(:user, :email => @user_email)
          fill_in "email", with: @user_email
          fill_in "name", with: @user_name
          fill_in "display_name", with: @user_display_name
          fill_in "password", with: "foobar"
          fill_in "password_confirmation", with: "foobar"
          click_link_or_button('Create Account')
        end

        it "should still be on the user creation page" do
          page.should have_selector("#registration_page")
        end

        it "should tell me that it can't have a duplicate email" do
          page.should have_content("Email has already been taken")
        end

        it "should allow me to correct it and resubmit" do
          fill_in "email", with: Faker::Internet.email
          fill_in "password", with: "foobar"
          fill_in "password_confirmation", with: "foobar"
          click_link_or_button('Create Account')
          page.should have_content("Sign-up complete! You're now logged in!")
        end

      end

      describe "visitor omits display name" do
        before(:each) do
          fill_in "email", with: @user_email
          fill_in "name", with: @user_name
          fill_in "password", with: "foobar"
          fill_in "password_confirmation", with: "foobar"
          click_link_or_button('Create Account')
        end

        it "sends me to the page I was on" do
          pending "TODO: Look into how to test what page was on/what page getting sent to. Feature is imp'd -JQ"
        end

        it "shows a flash message" do
          page.should have_selector("#alert")
        end

        it "confirms account creation with the flash message" do
          page.should have_content("Sign-up complete! You're now logged in!")
        end

        it "includes a link to view the new profile" do
          page.should have_content("My Profile")
        end

        it "sends an email confirmation" do
          pending "This is handled via the queue. Change the test to match"
          # ActionMailer::Base.deliveries.last.to.should == [@user_email]
          # ActionMailer::Base.deliveries.last.subject.should == "Welcome to Store Engine!"
        end


      end

    end

  end
end