# frozen_string_literal: true

# Create multiple orgs
# Create an item in each
# Make sure you can only see one org's item in one org

describe Item do

  let!(:item1) { Item.create! }
  let!(:org1) { Organization.current! }
  let!(:org2) { Organization.create! }
  let!(:item2) { org2.as_current { Item.create! } }
  let!(:item3) { org2.as_current { Item.create! } }

  specify "default org should have one item" do
    expect(Item.all).to eq [item1]
  end

  it "does not return item2" do
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

  class DependentClass
    include RailsMultitenant::GlobalContextRegistry::Current
    global_context_dependent_on Organization
  end

  class SubOrganization < Organization

  end

  describe ".current_id=" do
    before do
      Organization.current = org1
    end

    it "invalidates the cached object" do
      Organization.current_id = org2.id
      expect(Organization.current).to eq(org2)
    end

    it "invalidates the cached id" do
      Organization.current_id = org2.id
      expect(Organization.current_id).to eq(org2.id)
    end

    it "doesn't clear the cached object when set to the same current_id" do
      allow(Organization).to receive(:find).and_raise("Shouldn't be called")
      Organization.current_id = org1.id
      expect(Organization.current).to equal(org1)
    end
  end

  describe ".current=" do
    before do
      Organization.current = org1
    end

    it "invalidates the cached object" do
      Organization.current = org2
      expect(Organization.current).to eq(org2)
    end

    it "invalidates the cached id" do
      Organization.current = org2
      expect(Organization.current_id).to eq(org2.id)
    end

    it "doesn't clear the cached object when set to the same current" do
      allow(Organization).to receive(:find).and_raise("Shouldn't be called")
      Organization.current = org1
      expect(Organization.current).to equal(org1)
    end

    it "clears the cached object when set to a different instance of current" do
      Organization.current = Organization.find(Organization.current_id)
      expect(Organization.current).not_to equal(org1)
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
      dependent = DependentModel.create!
      DependentModel.current = dependent

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

  describe ".clear_current!" do
    let(:dependent) { DependentModel.create! }

    before do
      Organization.current = org2
      DependentModel.current = dependent
      Organization.clear_current!
    end

    it "clears the current object" do
      expect(Organization.current).to be_nil
    end

    it "clears the current id" do
      expect(Organization.current_id).to be_nil
    end

    it "clears the dependent current object" do
      expect(DependentModel.current).to be_nil
    end

    it "clears the dependent current id" do
      expect(DependentModel.current_id).to be_nil
    end
  end
end
