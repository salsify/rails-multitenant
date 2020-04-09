# frozen_string_literal: true

describe RailsMultitenant::GlobalContextRegistry do

  before do
    # The framework will setup the organization; clear that out
    RailsMultitenant::GlobalContextRegistry.new_registry
    RailsMultitenant::GlobalContextRegistry.set(:foo, 'bar')
  end

  describe ".get and .set" do
    specify do
      expect(RailsMultitenant::GlobalContextRegistry.get(:foo)).to eq 'bar'
    end
  end

  describe ".[] and .[]=" do
    before do
      RailsMultitenant::GlobalContextRegistry[:boo] = 'baz'
    end

    specify do
      expect(RailsMultitenant::GlobalContextRegistry[:boo]).to eq 'baz'
    end
  end

  describe ".delete" do
    specify do
      expect(RailsMultitenant::GlobalContextRegistry.delete(:foo)).to eq 'bar'
      expect(RailsMultitenant::GlobalContextRegistry.get(:foo)).to be_nil
    end
  end

  describe ".with_isolated_registry" do
    it "yields to the provided block" do
      expect { |b| RailsMultitenant::GlobalContextRegistry.with_isolated_registry(&b) }.to yield_control
    end

    it "does not inherit values from the current registry" do
      RailsMultitenant::GlobalContextRegistry.with_isolated_registry do
        expect(RailsMultitenant::GlobalContextRegistry.get(:foo)).to be_nil
      end
    end

    it "sets values provided as arguments" do
      RailsMultitenant::GlobalContextRegistry.with_isolated_registry(foo: 'updated') do
        expect(RailsMultitenant::GlobalContextRegistry.get(:foo)).to eq 'updated'
      end
    end

    it "restores the original registry after the block executes" do
      RailsMultitenant::GlobalContextRegistry.with_isolated_registry do
        # Do nothing
      end
      expect(RailsMultitenant::GlobalContextRegistry.get(:foo)).to eq('bar')
    end
  end

  describe ".replace_registry and .new_registry" do
    let!(:old_registry) { RailsMultitenant::GlobalContextRegistry.new_registry }

    specify do
      expect(old_registry).to eq(foo: 'bar')
    end
    specify do
      expect(RailsMultitenant::GlobalContextRegistry.get(:foo)).to be_nil
    end
    specify do
      RailsMultitenant::GlobalContextRegistry.replace_registry(old_registry)
      expect(RailsMultitenant::GlobalContextRegistry.get(:foo)).to eq 'bar'
    end

    context "when a new registry is specified" do
      let!(:old_registry) { RailsMultitenant::GlobalContextRegistry.new_registry(bar: 'foo') }

      specify do
        expect(old_registry).to eq(foo: 'bar')
      end
      specify do
        expect(RailsMultitenant::GlobalContextRegistry.get(:foo)).to be_nil
      end
      specify do
        expect(RailsMultitenant::GlobalContextRegistry.get(:bar)).to eq 'foo'
      end
    end
  end

  describe ".duplicate_registry" do
    def setup_registry; end

    before { setup_registry }

    let!(:dupe) { RailsMultitenant::GlobalContextRegistry.duplicate_registry }

    specify do
      expect(RailsMultitenant::GlobalContextRegistry.new_registry).to eq dupe
    end
    specify do
      expect(RailsMultitenant::GlobalContextRegistry.new_registry.object_id).not_to eq dupe.object_id
    end
    specify do
      expect(RailsMultitenant::GlobalContextRegistry.get(:foo).object_id).not_to eq dupe[:foo].object_id
    end

    context "with nils" do
      def setup_registry
        RailsMultitenant::GlobalContextRegistry.set(:bar, nil)
      end

      specify do
        expect(dupe).to eq RailsMultitenant::GlobalContextRegistry.new_registry
      end
    end

    context "with integers" do
      def setup_registry
        RailsMultitenant::GlobalContextRegistry.set(:bar, 5)
      end

      specify do
        expect(dupe).to eq RailsMultitenant::GlobalContextRegistry.new_registry
      end
    end
  end

  describe ".merge!" do
    it "merges values into the registry" do
      RailsMultitenant::GlobalContextRegistry.merge!(team: 'Eagles', color: 'Green')

      expect(RailsMultitenant::GlobalContextRegistry[:team]).to eq('Eagles')
      expect(RailsMultitenant::GlobalContextRegistry[:color]).to eq('Green')
    end

    it "overwrites existing values in the registry" do
      RailsMultitenant::GlobalContextRegistry[:team] = 'Patriots'

      RailsMultitenant::GlobalContextRegistry.merge!(team: 'Eagles', color: 'Green')

      expect(RailsMultitenant::GlobalContextRegistry[:team]).to eq('Eagles')
    end
  end

  describe ".with_merged_registry" do
    it "yields to the provided block" do
      expect { |b| RailsMultitenant::GlobalContextRegistry.with_merged_registry(foo: 'baz', &b) }.to yield_control
    end

    it "sets up a merged registry in the block" do
      RailsMultitenant::GlobalContextRegistry[:team] = 'Patriots'
      RailsMultitenant::GlobalContextRegistry.with_merged_registry(team: 'Eagles') do
        expect(RailsMultitenant::GlobalContextRegistry.get(:foo)).to eq('bar')
        expect(RailsMultitenant::GlobalContextRegistry.get(:team)).to eq('Eagles')
      end
    end

    it "restores the original registry after the block executes" do
      RailsMultitenant::GlobalContextRegistry[:team] = 'Patriots'
      RailsMultitenant::GlobalContextRegistry.with_merged_registry(team: 'Eagles') do
        # Do nothing
      end
      expect(RailsMultitenant::GlobalContextRegistry.get(:foo)).to eq('bar')
      expect(RailsMultitenant::GlobalContextRegistry.get(:team)).to eq('Patriots')
    end
  end

  describe ".with_admin_registry" do
    it "yields to the provided block" do
      expect { |b| RailsMultitenant::GlobalContextRegistry.with_unscoped_queries(&b) }.to yield_control
    end
  end
end
