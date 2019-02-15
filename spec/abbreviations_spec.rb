include RailsMultitenant

describe "Abbreviations" do
  it "aliases RailsMultitenant to RM" do
    expect(RM).to eq(RailsMultitenant)
  end

  describe "inner namespaces" do
    it "aliases GlobalContextRegistry to GCR" do
      expect(RM::GCR).to eq(RailsMultitenant::GlobalContextRegistry)
    end

    it "when setting values with abbreviations, they are visible to non-abbreviations" do
      RM::GCR[:organization_id] = 'Salsify Housing Authority'

      expect(RailsMultitenant::GlobalContextRegistry[:organization_id]).to eq('Salsify Housing Authority')
    end

    it "when setting values with non-abbreviations, they are visible to abbreviations" do
      RailsMultitenant::GlobalContextRegistry[:organization_id] = 'Salsify Co-op'

      expect(RM::GCR[:organization_id]).to eq('Salsify Co-op')
    end
  end
end
