# Changelog

### 0.9.0 
* Modify `Current.current` to return a specified default, when not already initialized, or `nil` 
  when no default is specified.    
* Add `Current.provide_default` to optionally specify a default value for `Current.current`.    
* Add `Current.current=` / `Current.current?` / `Current.current!` / `Current.as_current`.

### 0.8.0
* Switch usage of Fixnum to Integer for Ruby > 2.4 
* Test with multiple Rubies

### 0.7.2
* Fix bug that prevents clearing dependents of classes derived from CurrentInstance.  

### 0.7.1
* Added as_current multi-tenant class method.

### 0.7.0
* Add Rack middleware to create a new isolated registry per request.

### 0.6.0
* Rails 5.1 support.

### 0.5.2
* Optimize `CurrentInstance.current` / `CurrentInstance.current_id` / `CurrentInstance.current=` 
  / `CurrentInstance.current_id=`.

### 0.5.1
* Fix incorrect Rails version dependency in rubygems.org.

### 0.5.0
* Add `required` option to `multitenant_on` and `multitenant_on_model`.

### 0.4.0
* Fix be_multitenant_on matcher to handle models that don't include the `RailsMultitenant::MultitenantModel` module.
* Fix `context_entity_id_field` to work with inheritance.
* Drop Rails 3.2 and 4.0 support since `unscope` doesn't work propertly with default scopes.

### 0.3.1
* Fix strip_<entity>_scope

### 0.3.0
* Modify `RailsMultitenant::GlobalContextRegistry#new_registry` to accept an arg
  specifying the new registry to set. The previous registry is still returned.

### 0.2.0
* Merged [PR 2](https://github.com/salsify/rails-multitenant/pull/2) which adds support for 
  multi-tenancy based on a foreign key to an external model. As part of this the `multitenant_model_on`
  method was renamed to `multitenant_on_model`.
