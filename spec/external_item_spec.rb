# frozen_string_literal: true

include RailsMultitenant

describe ExternalItem do

  let!(:external_item1) { as_external_org(1) { ExternalItem.create! } }

  let!(:external_item2) { as_external_org(2) { ExternalItem.create! } }
  let!(:external_item3) { as_external_org(2) { ExternalItem.create! } }

  specify "org1 has the correct external items" do
    as_external_org(1) do
      expect(ExternalItem.all).to eq [external_item1]
    end
  end

  specify "org2 has the correct external items" do
    as_external_org(2) do
      expect(ExternalItem.all).to match_array [external_item2, external_item3]
    end
  end

  it "does not return external items from other orgs" do
    as_external_org(2) do
      expect(ExternalItem.where(id: external_item1.id)).to eq []
    end
  end

  it "allows the organization scope to be removed" do
    expect(ExternalItem.strip_external_organization_scope.count).to eq 3
  end

  def as_external_org(id, &block)
    GlobalContextRegistry.with_isolated_registry(external_organization_id: id, &block)
  end

end
