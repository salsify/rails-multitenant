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
  end

end
