module RailsMultitenant
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      dup._call(env)
    end

    def _call(env)
      GlobalContextRegistry.with_isolated_registry do
        @payload = @app.call(env)
      end

      @payload
    end
  end
end