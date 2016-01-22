# Changelog

### 0.3.0 (unreleased)
* Modify `RailsMultitenant::GlobalContextRegistry#new_registry` to accept an arg
  specifying the new registry to set. The previous registry is still returned.

### 0.2.0
* Merged [PR 2](https://github.com/salsify/rails-multitenant/pull/2) which adds support for 
  multi-tenancy based on a foreign key to an external model. As part of this the `multitenant_model_on`
  method was renamed to `multitenant_on_model`.
