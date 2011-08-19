require "spec_helper"

describe ActsAsRelatable::Relationship do

  it { should validate_presence_of :relator_id }
  it { should validate_presence_of :relator_type }
  it { should validate_presence_of :related_id }
  it { should validate_presence_of :related_type }

  before {
    @product = Product.create(:name => 'product1')
    @shop = Shop.create(:name => 'shop1')
  }

  context :associations do
    before { @product.relates_to! @shop }

    context :relator do
      it "returns the object that made the relation" do
        @product.relationships.first.relator.should == @product
      end
    end

    context :related do
      it "returns the object that has been related" do
        @product.relationships.first.related.should == @shop
      end
    end
  end


  context :make_between do
    context "relates two objects" do
      it "both sided by default" do
        expect {
          ActsAsRelatable::Relationship.make_between(@product, @shop)
        }.to change(ActsAsRelatable::Relationship, :count).by(2)
      end

      it "only one side" do
        expect {
          ActsAsRelatable::Relationship.make_between(@product, @shop, false)
        }.to change(ActsAsRelatable::Relationship, :count).by(1)
      end
    end
  end
end