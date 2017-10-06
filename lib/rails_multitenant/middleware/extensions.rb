require 'rails_multitenant/middleware/isolated_context_registry'

if defined?(Rails)
  require 'rails_multitenant/middleware/railtie'
end
