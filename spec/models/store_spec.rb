require 'spec_helper'

describe Store do
  context "creating stores" do

    context "and I enter invalid information" do
      it "does not let me create the store" do
        store1 = Store.new(:name => "", :url_name => "", :description => "")
        store1.save.should == false
      end
    end

    context "I try to create a store with conflicting name" do
      before(:each) do
        store1 = Store.new(:name => "", :url_name => "", :description => "")
      end

      it "won't let me use a name that already exists" do
        store2 = Store.new(:name => "", :url_name => "", :description => "")
        store2.save.should == false
      end
    end
  end
end
