module RailsMultitenant
  module MultitenantModel
    extend ActiveSupport::Concern

    included do
      class << self
        attr_accessor :context_entity_id_field
      end
    end

    module ClassMethods

      def multitenant_on(context_entity_id_field)
        self.context_entity_id_field = context_entity_id_field
        validates_presence_of context_entity_id_field

        context_entity = context_entity_id_field.to_s.gsub(/_id$/, '')
        scope_sym = "from_current_#{context_entity}".to_sym

        scope scope_sym, -> do
          where(context_entity_id_field => GlobalContextRegistry[context_entity_id_field])
        end

        default_scope { send(scope_sym) }

        scope "strip_#{context_entity}_scope", -> do
          unscope(where: context_entity_id_field)
        end
      end

      def multitenant_on_model(context_entity)
        multitenant_on("#{context_entity}_id".to_sym)
        belongs_to context_entity
      end

      def validates_multitenant_uniqueness_of(*attr_names)
        options = attr_names.extract_options!.symbolize_keys
        existing_scope = Array.wrap(options.delete(:scope))
        scope = existing_scope | [ context_entity_id_field ]
        validates_uniqueness_of(*attr_names, options.merge(scope: scope))
      end

    end
  end
end
