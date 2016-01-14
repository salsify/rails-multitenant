RSpec::Matchers.define(:be_multitenant_on) do |expected|
  match do |actual|
    actual.context_entity_id_field == expected
  end
end
