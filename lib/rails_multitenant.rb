# frozen_string_literal: true

require 'active_support/all'
require 'active_record'

require 'rails_multitenant/global_context_registry'
require 'rails_multitenant/multitenant_model'

require 'rails_multitenant/middleware/extensions'

module RailsMultitenant
  extend self

  delegate :get, :[], :fetch, :set, :[]=, :delete, :with_isolated_registry, :merge!, :with_merged_registry,
           to: :GlobalContextRegistry
end

# rails_multitenant/rspec has to be explicitly included by clients who want to use it
