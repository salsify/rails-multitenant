# frozen_string_literal: true

# Create multiple orgs
# Create an item in each
# Make sure you can only see one org's item in one org

describe Item do

  let!(:item1) { Item.create! }
  let(:dependent_class) do
    Class.new { include RailsMultitenant::GlobalContextRegistry::Current }
  end

  let!(:org2) { Organization.create! }
  let!(:item2) { org2.as_current { Item.create! } }
  let!(:item3) { org2.as_current { Item.create! } }

  before do
    Object.const_set(:DependentClass, dependent_class)
    Object.const_set(:SubOrganization, Class.new(Organization))

    DependentClass.global_context_dependent_on Organization
  end

  after do
    Object.send(:remove_const, :DependentClass)
    Object.send(:remove_const, :SubOrganization)
  end

  specify "default org should have one item" do
    expect(Item.all).to eq [item1]
  end

  it "does not return item2" do
    expect(Item.where(id: item2.id)).to eq []
  end

  it "behaves correctly when disabling scoping with a block" do
    RailsMultitenant::GlobalContextRegistry.with_unscoped_queries do
      expect(Item.where(id: item2.id)).to eq [item2]
    end
    expect(Item.where(id: item2.id)).to eq []
  end

  it "behaves correctly when disabling and enabling scoping without a block" do
    RailsMultitenant::GlobalContextRegistry.disable_scoped_queries
    expect(Item.where(id: item2.id)).to eq [item2]
    RailsMultitenant::GlobalContextRegistry.enable_scoped_queries
    expect(Item.where(id: item2.id)).to eq []
  end

  specify "org2 should have two items" do
    org2.as_current do
      expect(Item.all).to eq [item2, item3]
    end
  end

  it "does not return item1" do
    org2.as_current do
      expect(Item.where(id: item1.id)).to eq []
    end
  end

  describe ".as_current" do
    it "returns the correct items with an org supplied" do
      Organization.as_current(org2) do
        expect(Item.all).to eq [item2, item3]
      end
    end

    it "allows a nil org to be supplied" do
      Organization.as_current(nil) do
        expect(Item.all).to eq []
      end
    end

    it "rejects models of the wrong type" do
      model = Item.new
      expect { Organization.as_current(model) {} }.to raise_error("#{model} is not a Organization")
    end

    it "invalidates dependent models" do
      DependentModel.current = DependentModel.create!
      dependent = DependentModel.current

      SubOrganization.create!.as_current do
        expect(DependentModel.current).not_to equal(dependent)
      end
    end

    it "invalidates dependent objects" do
      dependent = DependentClass.new
      DependentClass.current = dependent

      SubOrganization.create!.as_current do
        expect(DependentClass.current).not_to equal(dependent)
      end
    end
  end
end
