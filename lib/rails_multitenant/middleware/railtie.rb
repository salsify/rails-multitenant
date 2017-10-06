module RailsMultitenant
  module Middleware
    class Railtie < ::Rails::Railtie
      initializer "rails_multitenant.middleware" do |app|
        app.config.middleware.insert 0, RailsMultitenant::Middleware
      end
    end
  end
end
