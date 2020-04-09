# frozen_string_literal: true

module RailsMultitenant
  module MultitenantModel
    extend ActiveSupport::Concern

    included do
      class_attribute :context_entity_id_field
    end

    module ClassMethods

      def multitenant_on(context_entity_id_field, required: true)
        self.context_entity_id_field = context_entity_id_field
        validates_presence_of(context_entity_id_field) if required

        context_entity = context_entity_id_field.to_s.gsub(/_id$/, '')
        scope_sym = "from_current_#{context_entity}".to_sym

        scope scope_sym, -> do
          unless GlobalContextRegistry[:use_unscoped_queries]
            where(context_entity_id_field => GlobalContextRegistry[context_entity_id_field])
          end
        end

        default_scope { send(scope_sym) }

        scope "strip_#{context_entity}_scope", -> do
          unscope(where: context_entity_id_field)
        end
      end

      def multitenant_on_model(context_entity, required: true)
        multitenant_on("#{context_entity}_id".to_sym, required: required)

        if ActiveRecord::VERSION::MAJOR < 5
          belongs_to(context_entity)
        else
          # Rails 5 added required validation to belongs_to associations and
          # an `optional` setting to disable it. We already do validation on
          # the foreign key so we always disable the native Rails validation.
          belongs_to(context_entity, optional: true)
        end
      end

      def validates_multitenant_uniqueness_of(*attr_names)
        options = attr_names.extract_options!.symbolize_keys
        existing_scope = Array.wrap(options.delete(:scope))
        scope = existing_scope | [context_entity_id_field]
        validates_uniqueness_of(*attr_names, options.merge(scope: scope))
      end

    end
  end
end
