# frozen_string_literal: true

require_relative 'registry_dependent_on'

module RailsMultitenant
  module GlobalContextRegistry
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
          raise "#{object} is not a #{self}" if object.present? && !object.is_a?(self)

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

        def as_current(model)
          old_model = current
          self.current = model
          yield
        ensure
          self.current = old_model
        end

        def clear_current!(cleared = [])
          GlobalContextRegistry.delete(current_instance_registry_obj)
          __clear_dependents!(cleared)
        end

        private

        def __clear_dependents!(cleared = [])
          cleared << self
          key_class = respond_to?(:base_class) ? base_class : self

          GlobalContextRegistry.send(:dependencies_for, key_class).each do |obj|
            obj.clear_current!(cleared) unless cleared.include?(obj)
          end
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
  end
end
