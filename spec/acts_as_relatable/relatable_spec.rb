require "spec_helper"

describe ActsAsRelatable::Relatable do

  before { @tag = Tag.create(:name => "tag1") }

  context :associations do
    context :without_content do
      subject { @tag.relationships }
      it { should be_empty }

      subject { @tag.incoming_relationships }
      it { should be_empty }

      subject { @tag.related_products }
      it { should be_empty }

      subject { @tag.related_shops }
      it { should be_empty}
    end
  end

  context :methods do
    before {
      @products = {
        :product1 => Product.create(:name => 'product1'),
        :product2 => Product.create(:name => 'product2'),
        :product3 => Product.create(:name => 'product3')
      }
      @shops = {
        :shop1 => Shop.create(:name => 'shop1'),
        :shop2 => Shop.create(:name => 'shop2'),
        :shop3 => Shop.create(:name => 'shop3')
      }
    }

    context :relates_to! do

      context :both_sided do
        before { @products[:product1].relates_to!(@shops[:shop3]) }

        it "relates the first side" do
          @products[:product1].related_to?(@shops[:shop3]).should be_true
        end

        it "relates the other side" do
          @shops[:shop3].related_to?(@products[:product1]).should be_true
        end
      end

      context :one_sided do
        before { @products[:product1].relates_to!(@shops[:shop3], :both_sided => false) }

        it "relates the first side" do
          @products[:product1].related_to?(@shops[:shop3]).should be_true
        end

        it "doesn't relate the other side" do
          @shops[:shop3].related_to?(@products[:product1]).should be_false
        end
      end

    end

    context :related_to? do
      context :returns do
        before { @products[:product1].relates_to!(@shops[:shop1]) }

        it "true if self is related to the passed object" do
          @products[:product1].related_to?(@shops[:shop1]).should be_true
        end

        it "false if self is not related to the passed object" do
          @products[:product1].related_to?(@shops[:shop2]).should be_false
        end
      end
    end

    context :relateds do
      context :returns do
        before {
          @products[:product1].relates_to!(@products[:product3])
          @products[:product1].relates_to!(@shops[:shop1])
        }

        it "elems of all classes if there is no class specified" do
          @products[:product1].relateds.should == {:shops => [@shops[:shop1]], :products => [@products[:product3]]}
        end

        it "objects from the specified classes only" do
          @products[:product1].relateds(:classes => 'Product').should == {:products => [@products[:product3]]}
        end

        it "nil if the specified class doesn't have content" do
          @products[:product1].relateds(:classes => 'Tag').should == {}
        end
      end
    end

    context :relation do
      before { @products[:product1].relates_to!(@shops[:shop1]) }

      context :returns do
        it "an instance of ActsAsRelatable::Relationship" do
          @products[:product1].relation(@shops[:shop1]).should be_an_instance_of ActsAsRelatable::Relationship
        end

        it "the related" do
          @products[:product1].relation(@shops[:shop1]).related.should == @shops[:shop1]
        end

        it "the relator" do
          @products[:product1].relation(@shops[:shop1]).relator.should == @products[:product1]
        end

        it "nil if there is no relation between self and the passed object" do
          @products[:product1].relation(@shops[:shop3]).should be_nil
        end
      end
    end

    context :destroy_relation_with do
      before {
        @products[:product1].relates_to!(@products[:product3])
        @products[:product1].relates_to!(@shops[:shop1])
      }

      context :after_destroy do
        before { @products[:product1].destroy_relation_with(@products[:product3]) }

        it "destroys the relationship containing the specified object" do
          @products[:product1].related_to?(@products[:product3]).should be_false
        end

        it "keeps the other relationship" do
          @products[:product1].related_to?(@shops[:shop1]).should be_true
        end
      end
    end
  end

end