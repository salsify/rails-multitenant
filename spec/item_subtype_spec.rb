# Create multiple orgs
# Create an item in each
# Make sure you can only see one org's item in one org

describe ItemSubtype do

  let!(:item1) { ItemSubtype.create! }

  let!(:org2) { Organization.create! }
  let!(:item2) { org2.as_current { ItemSubtype.create! } }
  let!(:item3) { org2.as_current { ItemSubtype.create! } }

  it 'inherits the multitenant settings from its parent class' do
    expect(ItemSubtype).to be_multitenant_on(:organization_id)
  end

  specify 'default org should have one item' do
    expect(ItemSubtype.all).to eq([item1])
  end

  it 'does not return item2' do
    expect(ItemSubtype.where(id: item2.id)).to eq([])
  end

  specify 'org2 should have two items' do
    org2.as_current do
      expect(ItemSubtype.all).to eq([item2, item3])
    end
  end

  it 'does not return item1' do
    org2.as_current do
      expect(ItemSubtype.where(id: item1.id)).to eq([])
    end
  end

end
