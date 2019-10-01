# frozen_string_literal: true

describe ItemWithOptionalOrg do

  let!(:item_without_org) { without_org { described_class.create! } }

  let!(:org) { Organization.create! }
  let!(:item_with_org) { org.as_current { described_class.create! } }

  let!(:other_org) { Organization.create! }
  let!(:item_with_other_org) { other_org.as_current { described_class.create! } }

  it "returns the correct items when no org is set" do
    without_org do
      expect(described_class.all).to eq([item_without_org])
    end
  end

  it "returns the correct items when an org is set" do
    org.as_current do
      expect(described_class.all).to eq([item_with_org])
    end
  end

  def without_org(&block)
    RailsMultitenant::GlobalContextRegistry.with_isolated_registry(&block)
  end
end
