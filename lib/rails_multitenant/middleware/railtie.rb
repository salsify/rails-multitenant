# frozen_string_literal: true

module RailsMultitenant
  module Middleware
    class Railtie < ::Rails::Railtie
      initializer 'rails_multitenant.middleware' do |app|
        app.config.middleware.insert 0, ::RailsMultitenant::Middleware::IsolatedContextRegistry
      end
    end
  end
end
