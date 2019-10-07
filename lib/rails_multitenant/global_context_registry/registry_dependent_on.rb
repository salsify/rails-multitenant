# frozen_string_literal: true

module RailsMultitenant
  module GlobalContextRegistry
    module RegistryDependentOn
      # Is this class dependent on changes in another GlobalContextRegistry-
      # stored object? Register that dependency here.
      def global_context_dependent_on(*klasses)
        klasses.each { |klass| GlobalContextRegistry.send(:add_dependency, klass, self) }
      end
    end
  end
end
