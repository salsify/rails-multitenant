RSpec::Matchers.define(:be_multitenant_on) do |expected|
  match do |actual|
    actual.respond_to?(:context_entity_id_field) && actual.context_entity_id_field == expected
  end
end
