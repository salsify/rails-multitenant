require 'spec_helper'
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
    specify do
      GlobalContextRegistry.with_isolated_registry do
        expect(GlobalContextRegistry.get(:foo)).to be_nil
      end
    end

    specify do
      GlobalContextRegistry.with_isolated_registry(foo: 'updated') do
        expect(GlobalContextRegistry.get(:foo)).to eq 'updated'
      end
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

    context 'with fixnums' do
      def setup_registry
        GlobalContextRegistry.set(:bar, 5)
      end

      specify do
        expect(dupe).to eq GlobalContextRegistry.new_registry
      end
    end
  end
end
