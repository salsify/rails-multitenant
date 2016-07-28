require 'rails_multitenant/rspec'

describe "be_multitenant_on matcher" do
  it "accepts a valid context field id" do
    expect(ExternalItem).to be_multitenant_on(:external_organization_id)
  end

  it "rejects an invalid context field id" do
    expect(ExternalItem).not_to be_multitenant_on(:other_field)
  end

  it "rejects classes that don't have a context field id" do
    expect(String).not_to be_multitenant_on(:other_field)
  end
end
