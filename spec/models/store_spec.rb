require 'spec_helper'

describe Store do
  context "creating stores" do
    context "and I've created a store" do
    let!(:store) {FactoryGirl.create(:store)}
    
      context "and I enter invalid information" do
        let(:new_store) {FactoryGirl.build(:store)}
        
        it "does not let me create the product" do
          expect { new_store.save}.to_not change { Store.count }.by(1)
        end
      end

    end
  end
end
