# RailsMultitenant

rails_multitenant is a gem for isolating ActiveRecord models from different tenants. The gem assumes tables storing
multi-tenant models include an appropriate tenant id column.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rails_multitenant'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rails_multitenant

If you're using Rails, there's nothing else you need to do.

Otherwise, you need to insert `RailsMultitenant::Middleware::IsolatedContextRegistry` into your middleware stack

## Usage

The gem supports two multi-tenancy strategies:

1. Based on a model attribute, typically a foreign key to an entity owned by another service
2. Based on a model association

The gem uses ActiveRecord default scopes to make isolating tenants fairly transparent.

### Multi-tenancy Based on Model Attributes

The following model is multi-tenant based on an `organization_id` attribute:

```ruby
class Product < ActiveRecord::Base
  include RailsMultitenant::MultitenantModel

  multitenant_on :organization_id
end
```

The model can then be used as follows:

```ruby
RailsMultitenant::GlobalContextRegistry[:organization_id] = 'my-org'

# Only returns products from 'my-org'
Product.all

# Returns products across all orgs
Product.strip_organization_scope.all

# Or set the current organization in block form
RailsMultitenant::GlobalContextRegistry.with_isolated_registry(organization_id: 'my-org') do
  # Only returns products from 'my-org'
  Product.all
end
```

By default this adds an ActiveRecord validation to ensure the multi-tenant attribute is present but this can be disabled
by passing `required: false` to `multitenant_on`.

### Multi-tenancy Based on Associated Models

The following model is multi-tenant based on an `Organization` model:

```ruby
class Product < ActiveRecord::Base
  include RailsMultitenant::MultitenantModel

  multitenant_on_model :organization
end
```

The model can then be used as follows:

```ruby
Organization.current_id = 1

# Only returns products from organization 1
Product.all

# Use the automatically generated belongs_to association to get
# a product's organization
Product.first.organization

# Or set the current organization in block form
Organization.as_current_id(1) do
  # Only returns products from organization 1
  Product.all
end
```

By default this adds an ActiveRecord validation to ensure the tenant model is present but this can be disabled
by passing `required: false` to `multitenant_on_model`.

### Abbreviations

When using `rails-multitenant` in a project, it is common to need to set values in `RailsMultitenant::GlobalContextRegistry` at the rails console.

This is difficult to type. Alternatively you can use `RM::GCR`. For example you might type `RM::GCR[:organization_id] = 'some value'` and it will have the same effect as the long version.

We do not recommend writing `RM::GCR` in source code, since what that means will be less obvious to future readers. The abbreviation is mainly intended as a console convenience.


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake false` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/salsify/rails-multitenant. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.

