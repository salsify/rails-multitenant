# encoding: UTF-8

ActiveRecord::Schema.define(:version => 0) do

  create_table(:organizations, force: true) do |t|
    t.string :name
  end

  create_table(:items, force: true) do |t|
    t.string :name
    t.integer :organization_id
  end

end

class Organization < ActiveRecord::Base
  include RailsMultitenant::GlobalContextRegistry::CurrentInstance
end

class Item < ActiveRecord::Base
  include RailsMultitenant::MultitenantModel
  multitenant_model_on :organization
end
