# frozen_string_literal: true

module RailsMultitenant
  module GlobalContextRegistry
    module RegistryDependentOn
      # Is this class dependent on changes in another GlobalContextRegistry-
      # stored object? Register that dependency here.
      def global_context_dependent_on(*klasses)
        klasses.each { |klass| GlobalContextRegistry.send(:add_dependency, klass, self) }
      end

      # Registers a bi-directional dependency on another class.
      def global_context_mutually_dependent_on(*klasses)
        global_context_dependent_on(*klasses)
        klasses.each { |klass| klass.global_context_dependent_on(self) }
      end
    end
  end
end
