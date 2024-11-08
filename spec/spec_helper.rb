# frozen_string_literal: true

require 'simplecov'
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
                                                                 SimpleCov::Formatter::HTMLFormatter,
                                                                 Coveralls::SimpleCov::Formatter
                                                               ])
SimpleCov.start do
  add_filter 'spec'
end

require 'active_record'

require 'logger'
require 'database_cleaner'
require 'rails_multitenant'
require 'yaml'

FileUtils.makedirs('log')

ActiveRecord::Base.logger = Logger.new('log/test.log')
ActiveRecord::Base.logger.level = Logger::DEBUG
ActiveRecord::Migration.verbose = false

db_adapter = ENV.fetch('ADAPTER', 'sqlite3')
db_config = YAML.safe_load(File.read('spec/db/database.yml'))
ActiveRecord::Base.establish_connection(db_config[db_adapter])
require 'db/schema'

RSpec.configure do |config|
  config.order = 'random'

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
    RailsMultitenant::GlobalContextRegistry.new_registry
    Organization.current_id = Organization.create!.id
  end

  config.after do
    DatabaseCleaner.clean
  end
end

puts "Testing with Ruby #{RUBY_VERSION} and ActiveRecord #{ActiveRecord::VERSION::STRING}"
