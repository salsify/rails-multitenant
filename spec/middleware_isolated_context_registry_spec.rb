# frozen_string_literal: true

describe Middleware::IsolatedContextRegistry do
  let(:payload) { [200, { 'Content-Type' => 'text/plain' }, ['OK']] }
  let(:app) { lambda { |env| env[2] = GlobalContextRegistry.get(:foo); env } }
  let(:middleware) { described_class.new(app) }

  describe ".call" do
    specify do
      GlobalContextRegistry.set(:foo, 'bar')
      # Assert that a new global registry is created and read from, where :foo is not set
      expect(middleware.call(payload)).to eq [200, { 'Content-Type' => 'text/plain' }, nil]
      # Assert that the outer global context registry is restored
      expect(GlobalContextRegistry.get(:foo)).to eq 'bar'
    end
  end
end
