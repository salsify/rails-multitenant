include RailsMultitenant

describe GlobalContextRegistry do

  before do
    # The framework will setup the organization; clear that out
    GlobalContextRegistry.new_registry
    GlobalContextRegistry.set(:foo, 'bar')
  end

  describe '.get and .set' do
    specify do
      expect(GlobalContextRegistry.get(:foo)).to eq 'bar'
    end
  end

  describe '.[] and .[]=' do
    before do
      GlobalContextRegistry[:boo] = 'baz'
    end

    specify do
      expect(GlobalContextRegistry[:boo]).to eq 'baz'
    end
  end

  describe '.delete' do
    specify do
      expect(GlobalContextRegistry.delete(:foo)).to eq 'bar'
      expect(GlobalContextRegistry.get(:foo)).to be_nil
    end
  end

  describe '.with_isolated_registry' do
    it "yields to the provided block" do
      expect { |b| GlobalContextRegistry.with_isolated_registry(&b) }.to yield_control
    end

    it "does not inherit values from the current registry" do
      GlobalContextRegistry.with_isolated_registry do
        expect(GlobalContextRegistry.get(:foo)).to be_nil
      end
    end

    it "sets values provided as arguments" do
      GlobalContextRegistry.with_isolated_registry(foo: 'updated') do
        expect(GlobalContextRegistry.get(:foo)).to eq 'updated'
      end
    end

    it "restores the original registry after the block executes" do
      GlobalContextRegistry.with_isolated_registry do
        # Do nothing
      end
      expect(GlobalContextRegistry.get(:foo)).to eq('bar')
    end
  end

  describe '.replace_registry and .new_registry' do
    let!(:old_registry) { GlobalContextRegistry.new_registry }

    specify do
      expect(old_registry).to eq({ foo: 'bar' })
    end
    specify do
      expect(GlobalContextRegistry.get(:foo)).to be_nil
    end
    specify do
      GlobalContextRegistry.replace_registry(old_registry)
      expect(GlobalContextRegistry.get(:foo)).to eq 'bar'
    end

    context 'when a new registry is specified' do
      let!(:old_registry) { GlobalContextRegistry.new_registry(bar: 'foo') }

      specify do
        expect(old_registry).to eq({ foo: 'bar' })
      end
      specify do
        expect(GlobalContextRegistry.get(:foo)).to be_nil
      end
      specify do
        expect(GlobalContextRegistry.get(:bar)).to eq 'foo'
      end
    end
  end

  describe '.duplicate_registry' do
    def setup_registry; end

    before { setup_registry }
    let!(:dupe) { GlobalContextRegistry.duplicate_registry }

    specify do
      expect(GlobalContextRegistry.new_registry).to eq dupe
    end
    specify do
      expect(GlobalContextRegistry.new_registry.object_id).not_to eq dupe.object_id
    end
    specify do
      expect(GlobalContextRegistry.get(:foo).object_id).not_to eq dupe[:foo].object_id
    end

    context 'with nils' do
      def setup_registry
        GlobalContextRegistry.set(:bar, nil)
      end

      specify do
        expect(dupe).to eq GlobalContextRegistry.new_registry
      end
    end

    context 'with integers' do
      def setup_registry
        GlobalContextRegistry.set(:bar, 5)
      end

      specify do
        expect(dupe).to eq GlobalContextRegistry.new_registry
      end
    end
  end

  describe '.merge!' do
    it "merges values into the registry" do
      GlobalContextRegistry.merge!(team: 'Eagles', color: 'Green')

      expect(GlobalContextRegistry[:team]).to eq('Eagles')
      expect(GlobalContextRegistry[:color]).to eq('Green')
    end

    it "overwrites existing values in the registry" do
      GlobalContextRegistry[:team] = 'Patriots'

      GlobalContextRegistry.merge!(team: 'Eagles')

      expect(GlobalContextRegistry[:team]).to eq('Eagles')
    end
  end

  describe '.with_merged_registry' do
    it "yields to the provided block" do
      expect { |b| GlobalContextRegistry.with_merged_registry(foo: 'baz', &b) }.to yield_control
    end

    it "sets up a merged registry in the block" do
      GlobalContextRegistry[:team] = 'Patriots'
      GlobalContextRegistry.with_merged_registry(team: 'Eagles') do
        expect(GlobalContextRegistry.get(:foo)).to eq('bar')
        expect(GlobalContextRegistry.get(:team)).to eq('Eagles')
      end
    end

    it "restores the original registry after the block executes" do
      GlobalContextRegistry[:team] = 'Patriots'
      GlobalContextRegistry.with_merged_registry(team: 'Eagles') do
        # Do nothing
      end
      expect(GlobalContextRegistry.get(:foo)).to eq('bar')
      expect(GlobalContextRegistry.get(:team)).to eq('Patriots')
    end
  end
end
