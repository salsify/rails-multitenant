# frozen_string_literal: true

require_relative 'registry_dependent_on'

module RailsMultitenant
  module GlobalContextRegistry
    # This module allows your to have a current, thread-local instance
    # of this class. It currently assumes your class has a zero-arg
    # constructor.
    module Current
      extend ActiveSupport::Concern

      included do
        class_attribute :default_provider, instance_writer: false
      end

      module ClassMethods
        def current
          GlobalContextRegistry.fetch(current_registry_obj) { __current_default }
        end

        def current=(object)
          raise "#{object} is not a #{self}" if object.present? && !object.is_a?(self)

          GlobalContextRegistry.set(current_registry_obj, object)
          __clear_dependents!
        end

        def current?
          GlobalContextRegistry.get(current_registry_obj).present?
        end

        def current!
          current || raise("No current #{name} set")
        end

        def clear_current!(cycle_detector = Set.new)
          GlobalContextRegistry.delete(current_registry_obj)
          __clear_dependents!(cycle_detector)
        end

        def as_current(object)
          old_object = current if current?
          self.current = object
          yield
        ensure
          self.current = old_object
        end

        include RegistryDependentOn

        def provide_default(provider = nil, &block)
          self.default_provider = provider ? provider.to_proc : block
        end

        private

        def current_registry_obj
          return @current_registry_obj if @current_registry_obj

          @current_registry_obj = "#{__key_class.name.underscore}_obj".to_sym
        end

        def current_registry_default_provider
          "#{__key_class.name.underscore}_default_provider".to_sym
        end

        def __current_default
          if default_provider
            default = default_provider.call(self)
            raise "#{default} is not a #{self}" if default.present? && !default.is_a?(self)

            default
          end
        end

        def __clear_dependents!(cycle_detector = Set.new)
          return if cycle_detector.include?(self)

          cycle_detector << self
          GlobalContextRegistry.send(:dependencies_for, __key_class).each do |obj|
            obj.clear_current!(cycle_detector)
          end
        end

        def __key_class
          respond_to?(:base_class) ? base_class : self
        end
      end

      def as_current
        old_object = self.class.current if self.class.current?
        self.class.current = self
        yield
      ensure
        self.class.current = old_object
      end

      def current?
        self.class.current? && equal?(self.class.current)
      end
    end
  end
end
