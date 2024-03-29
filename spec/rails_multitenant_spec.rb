# frozen_string_literal: true

describe "delegating to GlobalContextRegistry" do
  it "RailsMultitenant.get returns values from the GlobalContextRegistry" do
    RailsMultitenant::GlobalContextRegistry.set(:organization_id, 'Salsify Housing Authority')

    expect(RailsMultitenant.get(:organization_id)).to eq('Salsify Housing Authority')
  end

  it "RailsMultitenant[] returns values from the GlobalContextRegistry" do
    RailsMultitenant::GlobalContextRegistry.set(:organization_id, 'Salsify Farmland Inc.')

    expect(RailsMultitenant[:organization_id]).to eq('Salsify Farmland Inc.')
  end

  it "RailsMultitenant.set assigns values in the GlobalContextRegistry" do
    RailsMultitenant.set(:organization_id, 'Salsify Eminient Domain')

    expect(RailsMultitenant::GlobalContextRegistry.get(:organization_id)).to eq('Salsify Eminient Domain')
  end

  it "RailsMultitenant[]= assigns values in the GlobalContextRegistry" do
    RailsMultitenant[:organization_id] = 'Salsify Co-op'

    expect(RailsMultitenant::GlobalContextRegistry[:organization_id]).to eq('Salsify Co-op')
  end

  it "RailsMultitenant.fetch checks and sets the GlobalContextRegistry" do
    RailsMultitenant::GlobalContextRegistry[:organization_id] = nil

    # False positive from rubocop
    # rubocop:disable Style/RedundantFetchBlock
    expect(RailsMultitenant.fetch(:organization_id) { 'Salsify Anarchists' }).to eq('Salsify Anarchists')
    expect(RailsMultitenant.fetch(:organization_id) { 'Salsify Crypto Anarchists' }).to eq('Salsify Anarchists')
    # rubocop:enable Style/RedundantFetchBlock
  end

  it "RailsMultitenant.delete removes from the GlobalContextRegistry" do
    RailsMultitenant::GlobalContextRegistry[:organization_id] = 'Not Salsify'

    RailsMultitenant.delete(:organization_id)

    expect(RailsMultitenant.get(:organization_id)).to be_nil
  end

  it "RailsMultitenant.with_isolated_registry leverages the GlobalContextRegistry" do
    RailsMultitenant::GlobalContextRegistry[:organization_id] = 'Salsify Mainland'

    RailsMultitenant.with_isolated_registry(organization_id: 'Salsify Private Island') do
      expect(RailsMultitenant::GlobalContextRegistry[:organization_id]).to eq('Salsify Private Island')
    end

    expect(RailsMultitenant::GlobalContextRegistry[:organization_id]).to eq('Salsify Mainland')
  end

  it "RailsMultitenant.merge! adds values to the GlobalContextRegistry" do
    RailsMultitenant::GlobalContextRegistry[:organization_id] = 'Not Salsify'

    RailsMultitenant[:organization_id] = 'Salsify'

    expect(RailsMultitenant::GlobalContextRegistry[:organization_id]).to eq('Salsify')
  end

  it "RailsMultitenant.with_merged_registry runs the block with a merged registry" do
    RailsMultitenant::GlobalContextRegistry[:foo] = 'bar'

    RailsMultitenant.with_merged_registry(organization_id: 'Salsify') do
      expect(RailsMultitenant::GlobalContextRegistry[:foo]).to eq('bar')
      expect(RailsMultitenant::GlobalContextRegistry[:organization_id]).to eq('Salsify')
    end
  end

  it "RailsMultitenant.with_unscoped_queries does not remove existing context" do
    RailsMultitenant::GlobalContextRegistry[:organization_id] = 'Salsify'

    RailsMultitenant::GlobalContextRegistry.with_unscoped_queries do
      expect(RailsMultitenant::GlobalContextRegistry.use_unscoped_queries?).to eq true
      expect(RailsMultitenant::GlobalContextRegistry[:organization_id]).to eq('Salsify')
    end

    expect(RailsMultitenant::GlobalContextRegistry.use_unscoped_queries?).to eq false
  end

  it "RailsMultitenant.disabled_scoped_queries and enable_scoped_queries do not impact existing context" do
    RailsMultitenant::GlobalContextRegistry[:organization_id] = 'Salsify'

    RailsMultitenant::GlobalContextRegistry.disable_scoped_queries
    expect(RailsMultitenant::GlobalContextRegistry.use_unscoped_queries?).to eq true
    expect(RailsMultitenant::GlobalContextRegistry[:organization_id]).to eq('Salsify')

    RailsMultitenant::GlobalContextRegistry.enable_scoped_queries
    expect(RailsMultitenant::GlobalContextRegistry.use_unscoped_queries?).to eq false
    expect(RailsMultitenant::GlobalContextRegistry[:organization_id]).to eq('Salsify')
  end
end
