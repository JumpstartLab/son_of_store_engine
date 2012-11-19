require 'spec_helper'

describe "StaticPages" do
  describe "Home page" do

    it "should have the content 'Chez Pierre'" do
      visit '/'
      page.should have_content('Chez Pierre')
    end
  end
end
