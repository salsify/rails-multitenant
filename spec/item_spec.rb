# Create multiple orgs
# Create an item in each
# Make sure you can only see one org's item in one org

describe Item do

  let!(:item1) { Item.create! }

  let!(:org2) { Organization.create! }
  let!(:item2) { org2.as_current { Item.create! } }
  let!(:item3) { org2.as_current { Item.create! } }

  specify 'default org should have one item' do
    expect(Item.all).to eq [ item1 ]
  end

  it 'does not return item2' do
    expect(Item.where(id: item2.id)).to eq []
  end

  specify 'org2 should have two items' do
    org2.as_current do
      expect(Item.all).to eq [ item2, item3]
    end
  end

  it 'does not return item1' do
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

  describe '.as_current' do
    it 'returns the correct items with an org supplied' do
      Organization.as_current(org2) do
        expect(Item.all).to eq [ item2, item3]
      end
    end

    it 'allows a nil org to be supplied' do
      Organization.as_current(nil) do
        expect(Item.all).to eq []
      end
    end

    it 'rejects models of the wrong type' do
      model = Item.new
      expect { Organization.as_current(model) {}}.to raise_error("#{model} is not a Organization")
    end

    it 'invalidates dependent models' do
      DependentModel.current = DependentModel.create!
      dependent_id = DependentModel.current.object_id

      SubOrganization.create!.as_current do
        expect(DependentModel.current.object_id).not_to eq(dependent_id)
      end
    end

    it 'invalidates dependent objects' do
      dependent_id = DependentClass.current.object_id

      SubOrganization.create!.as_current do
        expect(DependentClass.current.object_id).not_to eq(dependent_id)
      end
    end
  end

end
