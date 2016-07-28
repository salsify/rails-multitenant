# encoding: UTF-8

ActiveRecord::Schema.define(version: 0) do

  create_table(:organizations, force: true)

  create_table(:items, force: true) do |t|
    t.integer :organization_id
    t.string :type
  end

  create_table(:external_items, force: true) do |t|
    t.integer :external_organization_id
  end
end

class Organization < ActiveRecord::Base
  include RailsMultitenant::GlobalContextRegistry::CurrentInstance
end

class Item < ActiveRecord::Base
  include RailsMultitenant::MultitenantModel
  multitenant_on_model :organization
end

class ItemSubtype < Item

end

class ExternalItem < ActiveRecord::Base
  include RailsMultitenant::MultitenantModel
  multitenant_on :external_organization_id
end

