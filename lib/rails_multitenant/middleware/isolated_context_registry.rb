# frozen_string_literal: true

module RailsMultitenant
  module Middleware
    class IsolatedContextRegistry
      def initialize(app)
        @app = app
      end

      def call(env)
        GlobalContextRegistry.with_isolated_registry do
          @app.call(env)
        end
      end
    end
  end
end
