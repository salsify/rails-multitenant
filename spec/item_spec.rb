# Create multiple orgs
# Create an item in each
# Make sure you can only see one org's item in one org

require 'spec_helper'

describe Item do

  let!(:item1) { Item.create(name: 'item1') }

  let!(:org2) { Organization.create(name: 'org2') }
  let!(:item2) { org2.as_current { Item.create(name: 'item2') } }
  let!(:item3) { org2.as_current { Item.create(name: 'item3') } }

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

end
