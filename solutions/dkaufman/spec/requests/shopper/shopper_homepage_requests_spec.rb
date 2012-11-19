require 'spec_helper'

describe "homepage" do
  let!(:enabled_store) { Fabricate(:store) }
  let!(:other_enabled_store) { Fabricate(:store) }
  let!(:disabled_store) { 
    store = Fabricate(:store)
    store.update_attribute(:enabled, false)
    store
  }
  before(:each) do
    visit "/"
  end

  it "has each enabled store" do
    [enabled_store, other_enabled_store].each do |store|
      page.should have_content store.name
    end
  end
  it "does not have disabled stores" do
    page.should_not have_content disabled_store.name
  end
end
