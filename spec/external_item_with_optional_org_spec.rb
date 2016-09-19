include RailsMultitenant

describe ExternalItemWithOptionalOrg do

  let!(:external_item_without_org) { as_external_org(nil) { described_class.create! } }

  let!(:external_item_with_org) { as_external_org(1) { described_class.create! } }
  let!(:external_item_with_other_org) { as_external_org(2) { described_class.create! } }

  specify 'the nil org has the correct external items' do
    as_external_org(nil) do
      expect(described_class.all).to eq([external_item_without_org])
    end
  end

  specify 'org1 has the correct external items' do
    as_external_org(1) do
      expect(described_class.all).to eq([external_item_with_org])
    end
  end

  def as_external_org(id, &block)
    GlobalContextRegistry.with_isolated_registry(external_organization_id: id, &block)
  end
end
