# frozen_string_literal: true

require_relative 'global_context_registry/current'
require_relative 'global_context_registry/current_instance'
require_relative 'global_context_registry/registry_dependent_on'

# Handles storing of global state that may be swapped out or unset at
# various points. We use this in dandelion to store the current user,
# org, catalog, etc.
#
# Note: You must ensure your entries are .dup'able.
#
module RailsMultitenant
  module GlobalContextRegistry
    extend self

    EMPTY_ARRAY = [].freeze

    # Set this global
    def set(symbol, value)
      globals[symbol] = value
    end
    alias_method :[]=, :set

    # delete this global
    def delete(symbol)
      globals.delete(symbol)
    end

    # Pass with a generator block for the value
    def fetch(symbol)
      result = globals[symbol]
      unless result
        result = yield
        globals[symbol] = result
      end
      result
    end

    # get the global identified by the symbol
    def get(symbol)
      globals[symbol]
    end
    alias_method :[], :get

    # merge the given values into the registry
    def merge!(values)
      globals.merge!(values)
    end

    # Duplicate the registry
    def duplicate_registry
      globals.transform_values do |value|
        value.nil? || value.is_a?(Integer) ? value : value.dup
      end
    end

    # Run a block of code with an the given registry
    def with_isolated_registry(registry = {})
      prior_globals = new_registry(registry)
      yield
    ensure
      self.globals = prior_globals
    end

    # Run a block of code with the given values merged into the current registry
    def with_merged_registry(values = {})
      prior_globals = new_registry(globals.merge(values))
      yield
    ensure
      self.globals = prior_globals
    end

    # Prefer .with_isolated_registry to the following two methods.
    # Note: these methods are intended for use in a manner like .with_isolated_registry,
    # but in contexts where around semantics are not allowed.

    # Set a new, by default empty registry, returning the previous one.
    def new_registry(registry = {})
      priors = globals
      self.globals = registry
      priors
    end

    # Replace the registry with one you previously took away with .new_registry
    def replace_registry(registry)
      self.globals = registry
    end

    # Run a block of code that disregards scoping during read queries
    def with_unscoped_queries
      # disabling Style/ExplicitBlockArgument for performance reasons
      with_merged_registry(__use_unscoped_queries: true) do
        yield
      end
    end

    def use_unscoped_queries?
      self[:__use_unscoped_queries] == true
    end

    # Prefer .with_unscoped_queries to the following two methods.
    # Note: these methods are intended for use in a manner like .with_admin_registry,
    # but in contexts where around semantics are not allowed.

    def disable_scoped_queries
      self[:__use_unscoped_queries] = true
    end

    def enable_scoped_queries
      self[:__use_unscoped_queries] = nil
    end

    private

    @dependencies = {}

    def add_dependency(parent, dependent)
      parent = parent.respond_to?(:name) ? parent.name : parent
      dependent = dependent.respond_to?(:name) ? dependent.name : dependent

      raise 'dependencies cannot be registered for anonymous classes' if parent.blank? || dependent.blank?

      ((@dependencies[parent] ||= []) << dependent).tap(&:uniq!)
    end

    def dependencies_for(klass)
      @dependencies[klass.name]&.map(&:safe_constantize)&.tap(&:compact!) || EMPTY_ARRAY
    end

    def globals
      registry = Thread.current[:global_context_registry]
      unless registry
        registry = {}
        Thread.current[:global_context_registry] = registry
      end
      registry
    end

    def globals=(value)
      Thread.current[:global_context_registry] = value
    end
  end
end
