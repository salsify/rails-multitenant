module RailsMultitenant
  module MultitenantModel
    extend ActiveSupport::Concern
=begin
    included do
      belongs_to :organization
      validates_presence_of :organization_id
      scope :from_current_org, -> { where(organization_id: Organization.current_id) }
      default_scope { from_current_org }
    end
=end

    included do
      class << self
        attr_accessor :context_entity_id_field
      end
    end

    module ClassMethods

      def multitenant_model_on(context_entity)
        @context_entity_id_field = "#{context_entity}_id"
        scope_sym = "from_current_#{context_entity}".to_sym

        belongs_to context_entity
        validates_presence_of context_entity_id_field
        scope scope_sym, -> { where(context_entity_id_field => context_entity.to_s.classify.constantize.current_id) }
        default_scope { send(scope_sym) }
        define_method "strip_#{context_entity}_scope" do
          unscope(where: context_entity_id_field)
        end
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
