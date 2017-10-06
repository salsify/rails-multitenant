require 'active_support/all'
require 'active_record'

require "rails_multitenant/global_context_registry"
require "rails_multitenant/multitenant_model"

require "rails_multitenant/middleware"
require "rails_multitenant/middleware/extensions"

# rails_multitenant/rspec has to be explicitly included by clients who want to use it
