class FooModel < ActiveRecord::Base
  include MultitenantModel

  mutlti_tenant_through Organization
end

# include GlobalContextRegistry::CurrentInstance
