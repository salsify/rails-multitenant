module RailsMultitenant
  module MultitenantModel
    extend ActiveSupport::Concern

    included do
      belongs_to :organization
      validates_presence_of :organization_id
      scope :from_current_org, -> { where(organization_id: Organization.current_id) }
      default_scope { from_current_org }
    end

    module ClassMethods

      def strip_organization_scope
        unscope(where: :organization_id)
      end

      def validates_organization_uniqueness_of(*attr_names)
        options = attr_names.extract_options!.symbolize_keys
        existing_scope = Array.wrap(options.delete(:scope))
        scope = existing_scope | [:organization_id]
        validates_uniqueness_of(*attr_names, options.merge(scope: scope))
      end

      def multitenant_recurse_destroy
        query = strip_organization_scope
        query.uniq.pluck(:organization_id).each do |org_id|
          # We'll set the current org and also filter the association. This way
          # associations will properly be destroyed and the association will
          # properly be filtered.
          Organization.as_current_id(org_id) do
            recurse_destroy(query.where(organization_id: org_id).pluck(:id))
          end
        end
      end

      def entity_counts_for_organizations(organization_ids)
        strip_organization_scope.where(organization_id: organization_ids).group(:organization_id).pluck(:organization_id, 'count(*)').to_h
      end

    end
  end
end
