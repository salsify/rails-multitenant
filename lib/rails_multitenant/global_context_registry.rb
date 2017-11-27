# Handles storing of global state that may be swapped out or unset at
# various points. We use this in dandelion to store the current user,
# org, catalog, etc.
#
# Note: You must ensure your entries are .dup'able.
#
module RailsMultitenant
  module GlobalContextRegistry

    extend self

    module RegistryDependentOn

      # Is this class dependent on changes in another GlobalContextRegistry-
      # stored object? Register that dependency here.
      def global_context_dependent_on(*klasses)
        klasses.each { |klass| GlobalContextRegistry.send(:add_dependency, klass, self) }
      end
    end

    # This module allows your to have a current, thread-local instance
    # of this class. It currently assumes your class has a zero-arg
    # constructor.
    module Current
      extend ActiveSupport::Concern

      module ClassMethods
        def current
          GlobalContextRegistry.fetch(current_registry_obj) { new }
        end

        def clear_current!
          GlobalContextRegistry.delete(current_registry_obj)
        end

        include RegistryDependentOn

        private

        def current_registry_obj
          key_class = respond_to?(:base_class) ? base_class : self
          "#{key_class.name.underscore}_obj".to_sym
        end
      end

    end

    # This module allows you to have a current, thread-local instance
    # of a class. This module assumes that you are mixing into a Rails
    # model, and separately stores and id in thread local storage for
    # lazy loading.
    module CurrentInstance
      extend ActiveSupport::Concern

      module ClassMethods
        def current_id=(id)
          GlobalContextRegistry.delete(current_instance_registry_obj)
          GlobalContextRegistry.set(current_instance_registry_id, id)
          __clear_dependents!
        end

        def current=(object)
          GlobalContextRegistry.set(current_instance_registry_obj, object)
          GlobalContextRegistry.set(current_instance_registry_id, object.try(:id))
          __clear_dependents!
        end

        def current_id
          GlobalContextRegistry.get(current_instance_registry_id)
        end

        def current
          GlobalContextRegistry.fetch(current_instance_registry_obj) do
            (current_id ? find(current_id) : nil)
          end
        end

        def current?
          !!current
        end

        def current!
          current || raise("No current #{name} set")
        end

        def as_current_id(id)
          old_id = current_id
          self.current_id = id
          yield
        ensure
          self.current_id = old_id
        end

        def as_current(model, &block)
          as_current_id(model&.id, &block)
        end

        def clear_current!
          GlobalContextRegistry.delete(current_instance_registry_obj)
        end

        private

        def __clear_dependents!
          GlobalContextRegistry.send(:dependencies_for, self).each(&:clear_current!)
        end

        def current_instance_registry_id
          return @current_instance_registry_id if @current_instance_registry_id

          key_class = respond_to?(:base_class) ? base_class : self
          @current_instance_registry_id = "#{key_class.name.underscore}_id".to_sym
        end

        def current_instance_registry_obj
          return @current_instance_registry_obj if @current_instance_registry_obj

          key_class = respond_to?(:base_class) ? base_class : self
          @current_instance_registry_obj = "#{key_class.name.underscore}_obj".to_sym
        end
        include RegistryDependentOn
      end

      def as_current
        old_id = self.class.current_id
        self.class.current = self
        yield
      ensure
        self.class.current_id = old_id
      end

      def current?
        id == self.class.current_id
      end

    end

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

    # Duplicate the registry
    def duplicate_registry
      globals.each_with_object({}) do |(key, value), result|
        result[key] = (value.nil? || value.is_a?(Fixnum)) ? value : value.dup
      end
    end

    # Run a block of code with an the given registry
    def with_isolated_registry(registry = {})
      prior_globals = new_registry(registry)
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

    private

    @dependencies = {}

    def add_dependency(parent, dependent)
      (@dependencies[parent] ||= []) << dependent
    end

    def dependencies_for(klass)
      @dependencies[klass] || []
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
      value
    end

  end
end
