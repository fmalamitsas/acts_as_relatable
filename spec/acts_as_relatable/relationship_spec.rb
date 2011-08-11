require "spec_helper"

describe ActsAsRelatable::Relationship do

  it { should validate_presence_of :relator_id }
  it { should validate_presence_of :relator_type }
  it { should validate_presence_of :related_id }
  it { should validate_presence_of :related_type }

  context :associations do
    before {
      @product = Product.create(:name => 'product1')
      @shop = Shop.create(:name => 'shop1')

      @product.relates_to! @shop
    }

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

end