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

    expect(RailsMultitenant.fetch(:organization_id) { 'Salsify Anarchists' }).to eq('Salsify Anarchists')

    expect(RailsMultitenant.fetch(:organization_id) { 'Salsify Crypto Anarchists' }).to eq('Salsify Anarchists')
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

  it "RailsMultitenant.with_admin_registry enables admin mode without removing existing context" do
    RailsMultitenant::GlobalContextRegistry[:organization_id] = 'Salsify'

    RailsMultitenant::GlobalContextRegistry.with_admin_registry do
      expect(RailsMultitenant::GlobalContextRegistry[:admin_registry_enabled]).to be_truthy
      expect(RailsMultitenant::GlobalContextRegistry[:organization_id]).to eq('Salsify')
    end

    expect(RailsMultitenant::GlobalContextRegistry[:admin_registry_enabled]).to be_falsey
  end
end
